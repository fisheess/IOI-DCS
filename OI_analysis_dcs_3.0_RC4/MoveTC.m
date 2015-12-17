global DATA PARA PREF;
for i=1:1:20
    PARA.cStimStart_s{PARA.showCurrDataSet}=PARA.cStimStart_s{PARA.showCurrDataSet}+1;
    PARA.cStimEnd_s{PARA.showCurrDataSet}=PARA.cStimEnd_s{PARA.showCurrDataSet}+1;
    fig = Test();
    updateTimecourse(handles.axes1);
    saveas(handles.displayTimecourse,['Bild' num2str(i) '.tif']); 
%     uiwait(gcf, 0.5);
end
