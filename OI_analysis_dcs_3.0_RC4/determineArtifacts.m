function [AP] = determineArtifacts( varargin )
%% Determine artifacts in an image 
%  
% input arguments
% I                     (double image) image to analyze
% fThreshold            (double) segmentation threshold
% AOI                   (logical image) area of interest, mostly the trepanation
% AM                    (logical image) activation mask, given mask for activation
% EP                    (cell {DATA.electrodePosX{i} DATA.electrodePosY{i}}) electrode position, used to determine activation
% nRadius               (integer default:50) max distance from center of electrodes; every label with a centroid outside this radius will not count towards the activation mask 
% bOverwriteAM          (logical default:0) if both AM and EP are supplied, AM can be overwritten

% output
% AP                    (struct) artefact properties
% AP.nlabelsInsideAOI   (integer) number of labels inside AOI
% AP.nlabelsInsideAOIwoAM(integer) number of labels inside AOI without AM
% AP.nlabelsOutsideAOI	(integer) number of labels outside AOI
% AP.nlabelsInsideAM 	(integer) number of labels inside AM
% AP.vMeanStdAOI        (integer vector) [Mean STD] inside AOI without AM
% AP.vMeanStdAOIwAM     (integer vector) [Mean STD] inside AOI with AM
% AP.vMeanStdAM         (integer vector) [Mean STD] inside AM
% AP.FFAM               (struct) Formfactors inside AM
% AP.FFAOI              (struct) Formfactors inside AOI but outside AM
% AP.FFNotAM            (struct) Formfactors outside AM
% AP.FFAll              (struct) Formfactors of whole Image

%% check input arguments
if nargin == 0,
  error ('No input arguments.');
end

%initialization
I       = 0;
fThreshold = 0;
AOI     = 0;
AM      = 0;
EP      = {[]};
nRadius = 50;
bOverwriteAM = false;

AP.nlabelsInsideAOI = 0;
AP.nlabelsInsideAOIwoAM = 0;
AP.nlabelsOutsideAOI= 0;
AP.nlabelsInsideAM  = 0;

AP.vMeanStdAOI      = [0 0];
AP.vMeanStdAM       = [0 0];
AP.vMeanStdAOIwAM   = [0 0];

AP.FFAM             = struct;
AP.FFAOI            = struct;
AP.FFNotAM          = struct;
AP.FFAll            = struct;


%% get parameters
if (rem(length(varargin),2)==1)
  error('Optional parameters should always go by pairs');
else
  for i=1:2:(length(varargin)-1)
    if ~ischar (varargin{i}),
      error (['Unknown type of optional parameter name (parameter' ...
	      ' names must be strings).']);
    end % if
    % change the value of parameter
    switch lower(varargin{i})
        case 'image'
            I = varargin{i+1};
        case 'threshold'
            fThreshold = varargin{i+1};
        case 'aoi'
            AOI = rot90(bwmorph(logical(varargin{i+1}),'clean'),2);
        case 'am'
            AM = bwmorph(logical(varargin{i+1}),'clean');
        case 'ep'
            EP = varargin{i+1};
        case 'radius'
            nRadius = varargin{i+1};
        case 'overwriteam'
            bOverwriteAM = logical(varargin{i+1});
        otherwise
         % Hmmm, something wrong with the parameter string
            error(['Unrecognized parameter: ''' varargin{i} '''']);
     end; % switch
  end; % for
end % if

%% check parameters
if I == 0
    error('No image!');
end
if fThreshold == 0
    warning('Threshold is set to zero!');
end
if AOI == 0
    warning('No area of interest supplied -- will be set to whole image!');
    AOI = true(size(I));
end
if isscalar(AM) && (isempty(EP{(1)}))
    warning('No activation mask or electrode position supplied -- will be set to whole image!');
    AM = true(size(I));
elseif ~isscalar(AM) && (~isempty(EP{(1)}))
    % Question user if either to use the AM or calculate via EP
    choice = questdlg('You supplied both an activation mask and electrode positions. Shall the activation mask be overwritten?', ...
     'Overwrite activation mask?', ...
     'Yes','No','Cancel','No');
    % Handle response
    switch choice
        case 'Yes'
            bOverwriteAM = true;
        case 'No'
            bOverwriteAM = false;
        case 'Cancel'
            error('You could not decide what to do.');
    end
end
if nRadius == 0
    error('Radius is set to zero!');
end % if

%% finally -- computation time \o/

I_seg = false(size(I));
I_seg(I >= fThreshold) = true;

% get labels
[L_AOI AP.nlabelsInsideAOI] = bwlabel(bwmorph(I_seg & AOI,'clean'));
[L_notAOI AP.nlabelsOutsideAOI] = bwlabel(bwmorph(I_seg & ~AOI,'clean'));

%  if not set get activation mask
if ( isscalar(AM) && (~isempty(EP{(1)})) ) || bOverwriteAM
    I_AOI_rotated = rot90(bwmorph(I_seg & AOI,'clean'),2); % electrode position is turned 180° 
    EP_center = [ (EP{1}(1) + EP{1}(2))/2 (EP{2}(1) + EP{2}(2))/2 ];
    stats = regionprops(I_AOI_rotated,'Centroid');
    count = [];
    for i=1:length(stats)
        % check if centroid lies within radius around center of electrodes
        if     sqrt( (stats(i).Centroid(1)-EP_center(1))^2 + (stats(i).Centroid(2)-EP_center(2))^2 ) <= nRadius
            count = [count i];
        end % if
    end % for
    
    % determine activation mask
    AP.nlabelsInsideAM  = length(count);
    AM = false(size(I));
    for i=1:length(count)
        AM(bwlabel(I_AOI_rotated) == count(i)) = true; % set pixels from labels inside radius true
    end %for
    AM = rot90(bwmorph(AM,'clean'),2);
% if activation mask is set
elseif ( ~isscalar(AM) && isempty(EP{(1)}) ) || ~isempty(EP{(1)})
    AP.nlabelsInsideAM = length(regionprops(bwmorph(AM,'clean')));
end %if

[L_AOIwoAM AP.nlabelsInsideAOIwoAM] = bwlabel(bwmorph(I_seg & AOI & ~AM,'clean'));

% mean+std
AP.vMeanStdAOI = [ mean2(I(bwmorph(AOI & ~AM,'clean'))) std2(I(bwmorph(AOI & ~AM,'clean')))];
AP.vMeanStdAM = [ mean2(I(AM)) std2(I(AM))];
AP.vMeanStdAOIwAM = [ mean2(I(AOI)) std2(I(AOI))];

% formfactors
AP.FFAM    = determineFormFactors(AM);
AP.FFAOI   = determineFormFactors(AOI & ~AM);
AP.FFNotAM = determineFormFactors(I_seg & ~AM);
AP.FFAll   = determineFormFactors(I_seg);

end %function
