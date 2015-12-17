%% --- update the timecourse axes -----------------------------------------
function updateTimecourse(timecourse_axes)

global DATA PARA PREF;
if PARA.showCurrDataSet
    % set stimparameter
    if PREF.stimParInd && ~isempty(PARA.cBaseStart_s{PARA.showCurrDataSet})
            baseStart_s = PARA.cBaseStart_s{PARA.showCurrDataSet};
            baseEnd_s = PARA.cBaseEnd_s{PARA.showCurrDataSet};
            stimStart_s = PARA.cStimStart_s{PARA.showCurrDataSet};
            stimEnd_s = PARA.cStimEnd_s{PARA.showCurrDataSet};
    else
            baseStart_s = PARA.baseStart_s;
            baseEnd_s = PARA.baseEnd_s;
            stimStart_s = PARA.stimStart_s;
            stimEnd_s = PARA.stimEnd_s;
    end

    set(gcf,'CurrentAxes',timecourse_axes);

    if ~isempty(DATA.time_s{PARA.showCurrDataSet})
        limit_x(1) = 0;
        limit_x(2) = DATA.time_s{PARA.showCurrDataSet}(end);
    else
        limit_x(1) = 0;
        limit_x(2) = 1;
    end

    if ~isempty(DATA.timecourse)
        limit_y(1) = min(DATA.timecourse);
% limit_y(1) = 1600;
        limit_y(2) = max(DATA.timecourse);
    else
        limit_y(1) = 0;
        limit_y(2) = 1;
    end

    plot([0 1],[0 1], 'LineStyle','none');
    hold on
    rectangle('Position',[baseStart_s, limit_y(1), baseEnd_s-baseStart_s, limit_y(2)-limit_y(1)],'FaceColor',[0.4 0.6 0.2],'LineStyle','none');
    rectangle('Position',[stimStart_s, limit_y(1), stimEnd_s-stimStart_s, limit_y(2)-limit_y(1)],'FaceColor',[0.8 0.8 0.2],'LineStyle','none');
    if ~isempty(DATA.timecourse)
        plot(DATA.time_s_binned{PARA.showCurrDataSet},DATA.timecourse);
    else
        plot(limit_x,limit_y,'LineStyle','none');
    end

    str_frame = ['frame: ', num2str(PARA.currentFrame)];
    str_time = ['time:  ',num2str(DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame)),' s'];
%     str_grayvl = ['grayvalue: ', num2str(DATA.timecourse(PARA.currentFrame))];


    if ~isempty(DATA.time_s_binned{PARA.showCurrDataSet})
        line([DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame) DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame)],limit_y,'LineStyle','-','Color','m');
        set(gca,'XTick',0:30:DATA.time_s_binned{PARA.showCurrDataSet}(end));
        if double(PARA.currentFrame)/double(PARA.nFrames{PARA.showCurrDataSet}) >= 0.8
            horAlign = 'right';
        else
            horAlign = 'left';
        end
%         text( DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame), limit_y(2)-(limit_y(2)-limit_y(1))/4, strvcat(str_frame,str_time), 'FontSize', 8,'HorizontalAlign',horAlign );

    end
        text( DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame), limit_y(2)-(limit_y(2)-limit_y(1))*0.1, char(str_time), 'FontSize', 8,'HorizontalAlign',horAlign );
        text( baseStart_s +(baseEnd_s-baseStart_s)*0.5,limit_y(2)-(limit_y(2)-limit_y(1))*0.9,'Base','FontSize',10,'HorizontalAlign','center');
        text( stimStart_s +(stimEnd_s-stimStart_s)*0.5,limit_y(2)-(limit_y(2)-limit_y(1))*0.9,'Stim','FontSize',10,'HorizontalAlign','center');
%         plot(DATA.time_s{PARA.showCurrDataSet}(PARA.currentFrame),DATA.timecourse(PARA.currentFrame),'Marker','x','MarkerEdgeColor','k','MarkerFaceColor','w','MarkerSize',8,'LineStyle','-','LineWidth',2,'Color','y');

    set(gca,'XLim',limit_x);
    set(gca,'YLim',limit_y);
    set(gca,'XGrid','on');
    xlabel('Time (in s)')
    ylabel('Gray value')
    if strcmp(get(gcf, 'name'), 'export_TC')
        title('Timecourse');
    end
    hold off
    clear frame;
end