%% --- updateAxesDiff--------------------------------------------------------------
function updateAxes(gui_elements)

global DATA PARA PREF;
% set(handles.txt_notification,'String','Busy');
error = uint8(0);
% PREF = getappdata(0,'PREF');
% set slider_threshold
% PARA.threshold_cur = get(gui_elements.slider_threshold,'Value');
% PARA.threshold_cur(PARA.threshold_cur > PARA.threshold_max) = PARA.threshold_max;
switch get(gui_elements.popup_show, 'Value')
    case 1 %reldiff
        set(gui_elements.slider_threshold,'Min',PARA.threshold_min);
        set(gui_elements.slider_threshold,'Max',PARA.threshold_max_rd);
        set(gui_elements.slider_threshold,'Value',PARA.threshold_cur_rd);
        set(gui_elements.edit_threshold_cur,'String',num2str(PARA.threshold_cur_rd));
    case 2 %tvalues
        set(gui_elements.slider_threshold,'Min',PARA.threshold_min);
        set(gui_elements.slider_threshold,'Max',PARA.threshold_max_tv);
        set(gui_elements.slider_threshold,'Value',PARA.threshold_cur_tv);
        set(gui_elements.edit_threshold_cur,'String',num2str(PARA.threshold_cur_tv));
    case 3 % corr coeff
        set(gui_elements.slider_threshold,'Min',PARA.threshold_min);
        set(gui_elements.slider_threshold,'Max',PARA.threshold_max_rd);
        set(gui_elements.slider_threshold,'Value',PARA.threshold_cur_rd);
        set(gui_elements.edit_threshold_cur,'String',num2str(PARA.threshold_cur_rd));
end

color_legend = {};
x = 1;
set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput); 
% legend('off');
% legend('DeleteLegend')
% get selected dataset in dirsToAnalyze for trepanation mask
% selection = get(handles.lb_dirsToAnalyze,'Value');
%try

    switch get(gui_elements.popup_show, 'Value')
        case 1 % reldiff
        thresholdImage = DATA.jointRelDiff;
    %         handles.threshold_max = PREF.maxRelDiff;
        % store partial masks for further use
        masks = DATA.mask_reldiff_i;
        case 2 %tvalues
        thresholdImage = DATA.jointTvalues;
    %         handles.threshold_max = PREF.maxTvalues;
        % store partial masks for further use
        masks = DATA.mask_tvalues_i;
%         case 3 % corr coeff
%         thresholdImage = DATA.jointCC;
%     %         handles.threshold_max = PREF.maxTvalues;
%         % store partial masks for further use
%         masks = DATA.mask_CC_i;
    end
% if isempty(thresholdImage)
%     thresholdImage = ones(PARA.frameSize);
% end

    % build activation mask
    if gui_elements.mask_contour || gui_elements.activation 
    % if checkboxes.activation 
        mask = false(PARA.frameSize);
        for i=1:1:size(PARA.subdirs,2)
            if PARA.subdirs{2,i}
                try 
                   mask = mask | masks{i};
                catch
                  error = 1;
                  errorMsg =['No mask for dataset ' PARA.subdirs{1,i} ' available! Please compute first!']; 
                end
            end
        end
    %         mask(mask > 1) = 1;
    end

    % cut thresholdimage to value range
    switch get(gui_elements.popup_show, 'Value')
        case 1 %reldiff
            thresholdImage(thresholdImage > PARA.threshold_cur_rd) = PARA.threshold_cur_rd;
            thresholdImage  = thresholdImage ./ PARA.threshold_cur_rd;
        case 2 %tvalues
            thresholdImage(thresholdImage > PARA.threshold_cur_tv) = PARA.threshold_cur_tv;
            thresholdImage  = thresholdImage ./ PARA.threshold_cur_tv;
%         case 3 % corr coeff
%             thresholdImage(thresholdImage > PARA.threshold_cur_rd) = PARA.threshold_cur_rd;
%             thresholdImage  = thresholdImage ./ PARA.threshold_cur_rd;
    end

    try
        if gui_elements.trepanation
            trepanationMask = DATA.trepanationMask{PARA.showCurrDataSet};
            if  ~isempty(thresholdImage)
                thresholdImage = thresholdImage .* imrotate(trepanationMask,180);
            end
        end
    catch
    end

    if  gui_elements.activation && length(PARA.dirsToAnalyze) == 1
            thresholdImage = mask.*thresholdImage;
    end

    thresholdImage_rgb = ind2rgb(round(thresholdImage .* 256), DATA.cmap_diff);


    if gui_elements.background_overlay || gui_elements.background_only || isempty(thresholdImage)

        GrayFrame = double(imread([PARA.pathname,'\', PARA.subdirs{1,PARA.showCurrDataSet},'\',PARA.filenames{PARA.showCurrDataSet}(PARA.currentFrame,:) ]));
        GrayFrame = GrayFrame ./PARA.grayMax;
        GrayFrame(GrayFrame>1) = 1 ;

        % create Overlay image
        overlay = zeros([PARA.frameSize 3]);

        if gui_elements.background_only || isempty(thresholdImage)
            for i=1:1:3
                    overlay(:,:,i) = GrayFrame;
            end
        else
            for i=1:1:3
               AlphaData = 1./(1+exp(-10.*(thresholdImage-0.5)));
               Buf = thresholdImage_rgb(:,:,i);
               overlay(:,:,i) = AlphaData .* Buf + ( ones(size(Buf))-AlphaData ) .* GrayFrame; 
            end
        end
    else
        overlay = thresholdImage_rgb;
    end
    % buffer = reshape(overlay,PARA.frameSize(1)*PARA.frameSize(2),3);

    DATA.activationImage_export =  imrotate(overlay,180);

    % set output
    set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput);

    image(imrotate(overlay,180));
    axis image;

    set(gui_elements.displayOutput,'Visible', 'off','Units', 'pixels');

    % update colorbar
    % axes(handles.axes_cbar);
    set(gui_elements.figure,'CurrentAxes',gui_elements.c_bar);
    image(DATA.CBar_diff);
    set(gui_elements.c_bar,'Visible', 'off','Units', 'pixels');
    % set(handles.txt_cbar_bottom,'String',num2str(PARA.threshold_cur));
    % set(handles.txt_cbar_top,'String',num2str(handles.threshold_max));
    % set(handles.edit_threshold_cur,'String',num2str(PARA.threshold_cur));
    set(gui_elements.txt_cbar_bottom,'String','0');
%     switch get(gui_elements.popup_show, 'Value')
%        case 1
%            PARA.threshold_max = PREF.maxRelDiff;
%        case 2
%            PARA.threshold_max = PREF.maxTvalues;
%     end

    % plot contours

    if gui_elements.mask_contour
    %     axes(handles.displayOutput);
        set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput);
        if length(PARA.dirsToAnalyze) == 1 || ~PREF.differentColors
            hold on;
%                 stats = regionprops(double(mask),'ConvexImage','BoundingBox');
%                 for i = 1:stats.BoundingBox(4)
%                     for j = 1:stats.BoundingBox(3)
%                         mask(round(stats.BoundingBox(2))+i,round(stats.BoundingBox(1))+j) = stats.ConvexImage(i,j);
%                     end
%                 end
                contour(rot90(mask,2),'Color',PREF.colors(1));
        %     overlay(mask) = 1;
            hold off;
        else
            subdirColors = {};
            subdirColors = 'Allocation dataset to color:';
            j = 1;
            hold on;
            for i=1:1:size(PARA.subdirs,2)
                if PARA.subdirs{2,i}
                    % reset j to 1 when bigger than 6, because colors 7 and 8
                    % are white and black which are senseless in a
                    % grayvalue-image
                    j(j>6) = 1;
                    contour(imrotate(masks{i},180),'Color',PREF.colors(i));
    %                   overlay(masks{i}) = 1-i/(size(PARA.subdirs,2));
                    subdirColors = [subdirColors ' ' PARA.subdirs{1,i} ' = ' PREF.colorsLong{j} ';'];
                    j = j+1;
                end
            end
            hold off;
            set(gui_elements.txt_notification,'String',subdirColors);
        end
        color_legend{x,1} = 'Mask contour';
        x = x+1;
    end

    if gui_elements.showROI
        set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput);
        hold on;
        contour(imrotate(DATA.BW{PARA.showCurrDataSet},180), 'LineColor', [0.3 1 0.2] ,'LineWidth',1);
    %     overlay(handles.BW) = 0.3;
        hold off;
        color_legend{x,1} = 'ROI';
        x = x+1;
    end
try
    if gui_elements.trepanation
        set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput); 
        hold on;
        contour(trepanationMask, 'c', 'LineWidth', 2);
        hold off;
        color_legend{x,1} = 'Trepanation';
        x = x+1;
    % %     for i=1:1:3
    % %         buf = overlay(:,:,i);
    % %         buf(imrotate(trepanationMask,180)) = 1;
    % %         overlay(:,:,i) = buf;
    % %     end
    % %     overlay(imrotate(bwmorph(trepanationMask,'remove'),180)) = 1;
    % %     buffer(imrotate(trepanationMask,180),1) =1;
    % %     buffer(imrotate(trepanationMask,180),2) =0;
    % %     buffer(imrotate(trepanationMask,180),3) =1;
    % %     overlay(imrotate(trepanationMask,180),1) =
    % %     buffer(imrotate(trepanationMask,180),1);
    %     hold off;
    end
% catch
%    error = 1;
%    errorMsg = 'No analysed data!';
% end
catch
end

if gui_elements.electrode
    drawElectrodes(gui_elements.displayOutput, gui_elements.electrode);
end


if strcmp(get(gui_elements.txt_notification,'String'),'Busy')
    set(gui_elements.txt_notification,'String','Ready');
end

if x>1 && ~PREF.differentColors && gui_elements.show_legend
    set(gui_elements.figure,'CurrentAxes',gui_elements.displayOutput); 
    legend(color_legend);
    set(legend,'color','none', 'TextColor', 'white');
end

if error
    set(gui_elements.txt_notification,'String',errorMsg);
end	
