%% 
function helper_checkShownDataset(handles)
global DATA PARA;
if PARA.showCurrDataSet
    if ~PARA.computed(PARA.showCurrDataSet)
        GrayFrame = double(imread([PARA.pathname,'\', PARA.subdirs{1,PARA.showCurrDataSet},'\',PARA.filenames{PARA.showCurrDataSet}(PARA.currentFrame,:) ]));
        GrayFrame = GrayFrame ./PARA.grayMax;
        GrayFrame(GrayFrame>1) = 1 ;
        overlay = zeros(PARA.frameSize(1),PARA.frameSize(2),3);
        for i=1:1:3
            overlay(:,:,i) = GrayFrame;
        end
        set(gcf,'CurrentAxes',handles.displayOutput);
        image(imrotate(overlay,180));
        axis image;
        set(handles.displayOutput,'Visible', 'off','Units', 'pixels');

        if get(handles.cbox_showROI,'Value')
            hold on
            contour(imrotate(DATA.BW{PARA.showCurrDataSet},180),'Color','b','LineWidth',2);
            hold off
        end
        if get(handles.cbox_electrode,'Value')
            drawElectrodes( handles.displayOutput, handles.cbox_electrode );
        end

    %          set(handles.displayOutput,'XTickLabel','');
    %     set(handles.displayOutput,'YTickLabel','');
    %      set(handles.displayOutput,'XTick',[]);
    %      set(handles.displayOutput,'YTick',[]);
    elseif get(handles.cbox_overlay, 'Value') ||get(handles.tb_bg_only, 'Value')
        gui_elements = helper_getGUIControlValues(handles);
        updateAxes(gui_elements);
    end
end
end %function