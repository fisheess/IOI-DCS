%% --- Draw electrodes in specified axes ----------------------------------
function drawElectrodes(output_window, cbox_electrodes)

% PREF = getappdata(0,'PREF');
global DATA PARA PREF;
iter = uint8(1);

set(gcf,'CurrentAxes',output_window);
hold on;
% image(getimage(handles.displayOutput));
if cbox_electrodes
    if ~isempty(PARA.subdirs)  % there are subdirs
        iter = size(PARA.subdirs,2);
    end
%     if iter == 1
%         try 
%             if ~isempty(DATA.electrodePosX{1})
%             plot(DATA.electrodePosX{1},DATA.electrodePosY{1},'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10,'LineStyle','none','LineWidth',2);
%             end
%         catch
%         end
%     else
        for i = 1:1:iter
        if PARA.subdirs{2,i}
           try
                if ~isempty(DATA.electrodePosX{i})
                    if PREF.drawElectrodeConn
                        plot(DATA.electrodePosX{i},DATA.electrodePosY{i},'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10,'LineStyle','-','LineWidth',2,'Color','y');
                        if PREF.drawElectrodeConnPar > 1
                            text( (DATA.electrodePosX{i}(1)+DATA.electrodePosX{i}(2))/2,(DATA.electrodePosY{i}(1)+DATA.electrodePosY{i}(2))/2,PARA.subdirs{1,i},'FontSize',12,'FontWeight','bold','Color','y');
                        end
                    else
                        plot(DATA.electrodePosX{i},DATA.electrodePosY{i},'Marker','o','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',10,'LineStyle','none','LineWidth',2,'Color','w');                    
                    end
                end
           catch
           end
%        end
           
        end
    end
end
hold off;
set(output_window,'Visible', 'off','Units', 'pixels');