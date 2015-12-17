function mask = calcMask( image, BW,  radius, maxdist, modus)
%% get activity mask for given image 
% get preferences
% prefs = getappdata(0,'prefs');
global PREF;

% image = image to find activationmask in
% BW = BW-image to reduce the area and hopefully improve the result
EA1 = image.*BW;

% zero pixels which are nan
% ~isnan() returns array where all not-nan are 1
EA1 = ~isnan(EA1).*EA1;
EA2 = imfilter(EA1, fspecial('gaussian',5,5*0.1213));
% calculate threshold
% threshold reldiff: 0.01-0.02
% threshold tvalues: 

if PREF.staticThreshold
    if modus == 1 %reldiff
    threshold = PREF.thresholdRelDiff;
    elseif modus == 0% tvalue
    threshold = PREF.thresholdTvalues;
    elseif modus == 2 %correl
    threshold = 0.5;
    elseif modus == 3 % fft
    threshold = 0.03;
    end
else
    meanValue = mean(EA2(BW));
    stdValue = std(EA2(BW));
    threshold = meanValue + stdValue;
end

% threshold = meanValue + stdValue;

% modus is 1 for reldiff, 0 for tvalue


% set all pixels beneath threshold to zero
EA3 = ones(size(EA1));
EA3(EA1<threshold) = 0;
% mask = EA3;
% remove noise
% radius equals neighbors around pixels with value 1
mask = logical(medfilt2(EA3, [radius radius] ));
% mask = imfilter(EA3, fspecial('gaussian',radius,radius*0.1213));
%     figure,imshow(mask), hold on
% label filtered image
L = bwlabel(mask);
stats = regionprops(L,'Area','PixelIdxList','Centroid');
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
        % if euclidean distance beneath max distance store pixels
        if sqrt(sum( (center-center2).^2 )) < maxdist
           % add pixel indizes of labels near biggest label
           idx = [idx; stats_new(i).PixelIdxList];
    %            plot(center2(1,1),center2(1,2),'x','LineWidth',2,'Color','green');
        end
        center2 = [];
    end 
catch
    idx = [];
end

mask = false(size(mask));
% activate only indexed pixels 
mask(idx) = true;