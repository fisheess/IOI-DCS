function AM = determineMask( varargin)

global PREF;

%% check input arguments
if nargin == 0,
  error ('No input arguments.');
end

%initialization
I       = 0;
% fThreshold = 0;
AOI     = 0;
EP      = {[]};
nRadius = PREF.maxdist;
nModus = 0;


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
%         case 'threshold'
%             fThreshold = varargin{i+1};
        case 'aoi'
            AOI = bwmorph(logical(varargin{i+1}),'clean');
        case 'ep'
            EP = varargin{i+1};
%         case 'radius'
%             nRadius = varargin{i+1};
        case 'modus'
            nModus = varargin{i+1};
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
% if fThreshold == 0
%     warning('Threshold is set to zero!');
% end
if AOI == 0
    warning('No area of interest supplied -- will be set to whole image!');
    AOI = true(size(I));
end
if nRadius == 0
    error('Radius is set to zero!');
end % if

%% get activity mask for given image 
% image = image to find activationmask in
% BW = BW-image to reduce the area and hopefully improve the result

I_filtered = imfilter(I, fspecial('gaussian',5,5*0.1213));
% calculate threshold

if PREF.staticThreshold
    if nModus == 1 %reldiff
    threshold = PREF.thresholdRelDiff;
    elseif nModus == 0% tvalue
    threshold = PREF.thresholdTvalues;
    end
else
    meanValue = mean(EA2(BW));
    stdValue = std(EA2(BW));
    threshold = meanValue + stdValue;
end

% threshold = meanValue + stdValue;

% modus is 1 for reldiff, 0 for tvalue


% set all pixels beneath threshold to zero
I_seg = false(size(I_filtered));
I_seg(I_filtered>threshold) = true;
% mask = EA3;
% remove noise
% radius equals neighbors around pixels with value 1
% mask = logical(medfilt2(EA3, [radius radius] ));
I_seg = medfilt2(bwmorph(bwmorph(I_seg,'clean'),'close'),[PREF.radius PREF.radius]);
% mask = imfilter(EA3, fspecial('gaussian',radius,radius*0.1213));
%     figure,imshow(mask), hold on
% label filtered image

if isempty(EP{(1)})
    stats = regionprops(bwlabel(I_seg & AOI),'Area','PixelIdxList','Centroid');
    % sort labels in descending order by their area-size
    [unused order] = sort([stats(:).Area],'descend');
    stats_new = stats(order);
    % get coordinates of center-of-mass of biggest label
    try 
        center = stats_new(1).Centroid;
        % store corresponding indexed pixels
        idx = stats_new(1).PixelIdxList;

        %     plot(center(1,1),center(1,2),'x','LineWidth',2,'Color','red');

        for i = 2:1:length(stats_new)

            center2 = stats_new(i).Centroid;
        %         plot(center2(1,1),center2(1,2),'x','LineWidth',2,'Color','cyan');
            % if euclidean distance beneath max distance store pixels and
            % area min 10% of biggest area
            if sqrt(sum( (center-center2).^2 )) < nRadius && stats_new(1).Area*0.05 < stats_new(i).Area
%             if sqrt(sum( (center-center2).^2 )) < nRadius
               % add pixel indizes of labels near biggest label
               idx = [idx; stats_new(i).PixelIdxList];
        %            plot(center2(1,1),center2(1,2),'x','LineWidth',2,'Color','green');
            end
            center2 = [];
        end 
    catch
        idx = [];
    end
    AM = false(size(I_seg));
    % activate only indexed pixels 
    AM(idx) = true;
else
    I_AOI_rotated = rot90(I_seg & AOI,2); % electrode position is turned 180° 
    EP_center = [ (EP{1}(1) + EP{1}(2))/2 (EP{2}(1) + EP{2}(2))/2 ];
    stats = regionprops(bwlabel(I_AOI_rotated),'Centroid','Area');
    count = [];
    for i=1:length(stats)
        % check if centroid lies within radius around center of electrodes
        distance = sqrt( (stats(i).Centroid(1)-EP_center(1))^2 + (stats(i).Centroid(2)-EP_center(2))^2 );
        if    distance <= nRadius
            count = [count i];
        end % if
    end % for
    
    % determine activation mask
%     AP.nlabelsInsideAM  = length(count);
    [unused order] = sort([stats(:).Area],'descend');
    stats_new = stats(order);
    AM = false(size(I));
    for i=1:length(count)
        % set pixels from labels inside radius  and bigger than 10% of biggest label to true
        AM(bwlabel(I_AOI_rotated) == count(i) & (stats_new(1).Area*0.05 < stats(count(i)).Area)) = true; 
%         AM(bwlabel(I_AOI_rotated) == count(i)) = true; 
    end %for
    AM = rot90(AM,2);
end
