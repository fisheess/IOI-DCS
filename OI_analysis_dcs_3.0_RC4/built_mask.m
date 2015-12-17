%% ------------------------------------------------------------------------
function [trepMask] = trepanation_mask(image, interaction)
%get current computation parameters
global PARA;

% medianfiltersize = PARA.medianfiltersize;
% strelsize = getappdata(0, 'strelsize');
% graylvlfactor = getappdata(0, 'graylvlfactor');
%calculate graylevel threshhold (Otsus method)
level = graythresh(image)* PARA.graylvlfactor;
% figure(); imshow(image);
%convert image to bw image
BW = im2bw(image, level);
% figure(); imshow(BW);
% apply median filter on image
BW = medfilt2(BW, [PARA.medianfiltersize PARA.medianfiltersize]);
%figure(); imshow(BW);
%morphologically close image with structure element 'disk'
se = strel('disk',PARA.strelsize);
closeBW = imclose(BW,se);
%fill holes
BW2 = imfill(closeBW, 'hole');
%figure(); imshow(BW2);
%plot boundaries
% [B,L,N] = bwboundaries(BW2);
if interaction
    figure; imshow(image); hold on;
%     for k=1:length(B),
%         boundary = B{k};
%         if(k > N)
%             plot(boundary(:,2),...
%                 boundary(:,1),'g','LineWidth',2);
%         else
% 
%             plot(boundary(:,2),...
%                 boundary(:,1),'c','LineWidth',3,'LineStyle',':');
%         end
%     end
    imcontour(BW2,2,'r');
    selection = questdlg('Accept detected region as trepanation mask?',...
          'Trepanation mask',...
          'Yes','No','Set manually', 'Yes'); 
       switch selection, 
          case 'Yes',
             delete(gcf);
             trepMask = BW2;
          case 'No'
              Trep_param;
              waitfor(Trep_param);
              delete(gcf);
              trepMask = built_mask(image, 1);
          case 'Set manually'
               ROI = roipoly(image);
               delete(gcf);
              trepMask = ROI;    
       end
else
    trepMask = BW2;
end