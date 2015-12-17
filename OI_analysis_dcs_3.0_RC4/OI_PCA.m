function [U, S, V, PC, MeanFrame, StdFrame, PC_norm] = OI_PCA(rank, Data)

% if isempty(Pathname)
%     Pathname = uigetdir('e:\OpticalImaging\IntraopAufnahmen\','Select directory with images');
% end
% 
% % get the image file names
% [Filenames] = getFilenamesFromDir(Pathname,'tif');
% 
% % bumber of frames
% nFrames = size(Filenames,1);
% 
% % read the first frame to get some information about it
% Frame1 = imread( fullfile( Pathname, Filenames(1,:) ) );
% 
% nRows = size(Frame1,1);
% nCols = size(Frame1,2);
% 
% Data = zeros(nRows*nCols,floor(nFrames/3),'double');
% 
% SpatialFilterKernel = fspecial('gaussian',7,7*0.1213);
% 
% % calc mean image
% h_wait = waitbar(0,'doing stuff...');
% for j=1:3:floor(nFrames/3)
%    
%     waitbar(j/nFrames,h_wait);
% 
%     % get the frame
%     Frame = imread( fullfile( Pathname, Filenames(j,:) ) );
%     
%     Frame = imfilter(Frame,SpatialFilterKernel);
%      
%     Frame = reshape(Frame,nRows*nCols,1);
%     
%     Data(:,j)=Frame;  
%     
% end
% close(h_wait);

%MeanFrame = mean(Data(:,1:141),2);
MeanFrame = mean(Data,2);
StdFrame = std(Data,0,2);

nFrames = size(Data,2);

for k=1:1:floor(nFrames)
    Data(:,k) = Data(:,k)-MeanFrame;   
end

[U, S, V] = pca(Data,rank);

for l=1:1:rank
   PC(:,:,l) = reshape(U(:,l),520,692);
%     PC(:,:,l) = reshape(U(:,l),344,460);
end

% normalize data
% for l=1:1:rank
%     buf = PC(:,:,l);
%     minPC = min(buf(:));
%     buf = buf - minPC;
%     maxPC = max(buf(:));
%     PC(:,:,l) = buf./maxPC;
% end

for i=1:rank
    buf = PC(:,:,i);
    x_neg = [-0.1:0.005:-.005];
    x_pos = [.005:0.005:.1];
   
    histB_neg = histc(buf,x_neg);
    histB_pos = histc(buf,x_pos);
    nHistPos = length(find(histB_pos > 50)); 
    nHistNeg= length(find(histB_neg > 50));
    
    maxB = max(buf(:));
    minB = min(buf(:));
%     if a >= b
% %         normalB = maxB;
%         buf = buf - minB;
%     else
% %         normalB = abs(minB);
% %         buf = imcomplement(buf);
%         buf = buf - maxB;
%         buf = -buf;
%     end
    
    if nHistPos == 0 && nHistNeg == 0
%        PC(:,:,i) = [];
%        rank = rank - 1;
%        buf = [];
    elseif nHistPos < nHistNeg
       buf = buf - maxB;
       buf = -buf;   
    end

    PC_norm(:,:,i) = buf./(maxB-minB);
    PC_bin(:,:,i) = im2bw(PC_norm(:,:,i),0.45);
end

%% find component with largest complex

% first component is always hearbeat and respiration

for i=1:rank
    maxdist = 80;
    buf = PC_bin(:,:,i);
    L = bwlabel(buf);
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

        for j = 2:1:length(stats_new)

            center2 = stats_new(j).Centroid;
        %         plot(center2(1,1),center2(1,2),'x','LineWidth',2,'Color','cyan');
            % if euclidean distance beneath max distance store pixels
            if sqrt(sum( (center-center2).^2 )) < maxdist
               % add pixel indizes of labels near biggest label
               idx = [idx; stats_new(j).PixelIdxList];
        %            plot(center2(1,1),center2(1,2),'x','LineWidth',2,'Color','green');
            end
            center2 = [];
        end 
    catch
        idx = [];
    end
    buf = logical(zeros(size(buf)));
    % activate only indexed pixels 
    buf(idx) = true; 
    PC_bin(:,:,i) = buf;
end

%% --------------------------------------------------------------------------
% figure('Name','Principal Components (positive)');
% for m=1:1:rank
%    subplot(2,rank./2,m); imshow( imrotate(PC(:,:,m),180));%,[0 0.01]);
%    hold on
%    title(['PC',num2str(m)]);
%    colormap(jet(256));
%    hold off
% end

% figure('Name','Principal Components (negative)');
% for n=1:1:rank
%    subplot(2,rank./2,n); imshow( imrotate((PC(:,:,n).*-1),180));%,[0 0.01]);
%    hold on
%    colormap(jet(256));
%    title(['PC',num2str(n)]);
%    hold off
% end

figure('Name','Principal Components');
for p=1:1:rank
   subplot(2,rank./2,p); imshow( imrotate(PC(:,:,p),180),[-0.03 0.03]);
   hold on
   colormap(jet(256));
   colorbar;
   title(['PC',num2str(p)]);
   hold off
end

figure('Name','Principal Components (binary)');
for p=1:1:rank
   idx = find(PC_bin(:,:,p));
   maxPixel = size(PC_bin(:,:,p),1) * size(PC_bin(:,:,p),2);
   if length(idx) <= 1*maxPixel
       subplot(2,rank./2,p); imshow( imrotate(PC_bin(:,:,p),180));%,[-0.01 0.01]);
       hold on
    %    colormap(jet(256));
    %    colorbar;
       title(['PC',num2str(p),'  Pixel: ',num2str(length(find(PC_bin(:,:,p))))]);
       hold off
   end
end


figure('Name','Principal Components (normalized)');
for p=1:1:rank
   subplot(2,rank./2,p); imshow( imrotate(PC_norm(:,:,p),180));%,[-0.01 0.01]);
   hold on
   colormap(jet(256));
   colorbar;
   title(['PC',num2str(p)]);
   hold off
end


figure('Name','Eigentimecourses');
for o=1:1:rank
   subplot(2,rank./2,o); plot( V(:,o) );
   hold on
   colormap(jet(256));
   title(['TC',num2str(o)]);
   hold off
end

MeanFrame = reshape(MeanFrame,520,692);
StdFrame = reshape(StdFrame,520,692);


return