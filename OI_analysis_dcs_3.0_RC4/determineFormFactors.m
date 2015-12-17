function [formFactors] = determineFormFactors(data,varargin)
%% Determine form factors for either images or masks
%  - masks need to be binary
%  - images need additonal threshold values (or they will set from mean +
%  standard deviation)

% form factors:
% - area
% - perimeter
% - centroid
% - center
% - bounding box
% - distance between center and centroid
% - ratio of area/boundingboxArea
% - ratio of area/convexhullArea
%
% doc regionsprops

% check input arguments
if nargin == 0,
  error ('No input arguments.');
end
if islogical(data)
    bImage = false;
    bMask = true;
elseif isnumeric(data)
    bImage = true;
    bMask = false;
else
    error('First input argument has to be a logical or numeric array!')
end

%initialization
formFactors.Area = 0;
formFactors.Centroid = 0;
formFactors.BoundingBox = [ 0 0 0 0];
formFactors.Extent = 0;
formFactors.Solidity = 0;
formFactors.Center = [0 0];
formFactors.Distance = 0;
formFactors.Perimeter = 0;


% get parameters
if (rem(length(varargin),2)==1)
  error('Optional parameters should always go by pairs');
else
  for i=1:2:(length(varargin)-1)
    if ~ischar (varargin{i}),
      error (['Unknown type of optional parameter name (parameter' ...
	      ' names must be strings).']);
    end % if
    % change the value of parameter
    switch varargin{i}
        case 'threshold'
            fThreshold = varargin{i+1}; % not used yet
        otherwise
         % Hmmm, something wrong with the parameter string
            error(['Unrecognized parameter: ''' varargin{i} '''']);
     end; % switch
  end; % for
end % if

% binary mask supplied
if bMask && (length(find(data)) > 0)
    L = double(data); % all active pixels count as one single label
    formFactors = regionprops(L,'Area','BoundingBox','Centroid','Extent','Solidity'); % Extent = Area/BoundingBoxArea; Solidity = Area/ConvexHullArea;
    formFactors.Center = [formFactors.BoundingBox(1)+formFactors.BoundingBox(3)/2 formFactors.BoundingBox(2)+formFactors.BoundingBox(4)/2];
    formFactors.Distance = sqrt( (formFactors.Centroid(1)-formFactors.Center(1))^2 + (formFactors.Centroid(2)-formFactors.Center(2))^2); % euclidean distance between center and centroid
    L = bwlabel(data); % Perimeter has be estimated differently
    stats = regionprops(L,'Perimeter');
    formFactors.Perimeter = 0;
    for i = 1:length(stats)
        formFactors.Perimeter = formFactors.Perimeter + stats(i).Perimeter;
    end
end%if

end % function