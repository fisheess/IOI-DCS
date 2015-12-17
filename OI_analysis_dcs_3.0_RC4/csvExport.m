function  xlsExport()

global DATA PARA;

count = find(PARA.computed);
% find patient name
ind=strfind(PARA.pathname,'\');
pos=ind(end)+1;
string=PARA.pathname(pos:end);

% add analysed datasets
for i=1:length(count)
    string = [string '_' PARA.subdirs{1,count(i)}];  
end

[filename, pathname] = uiputfile([string '.xls'],'Save as...');

content = {'Dataset','MeanRD','StdRD', 'MinRD', 'MaxRD', 'MeanTV','StdTV', 'MinTV', 'MaxTV'};
% dlmwrite([pathname filename],title,'delimiter','','newline','pc');
values = 0;
% put statistic data to .csv-file
for i=1:length(count)
    
    dataSet = PARA.subdirs{1,count(i)};
    mean_rd = mean(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
    std_rd = std(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
    min_rd = min(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
    max_rd = max(DATA.relDiffPos{count(i)}(DATA.mask_reldiff_i{count(i)}));
    mean_tv = mean(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
    std_tv = std(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
    min_tv = min(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
    max_tv = max(DATA.tvaluesPos{count(i)}(DATA.mask_tvalues_i{count(i)}));
    
%     if size(values,1) > 1
%         values = [values; [dataSet mean_rd std_rd min_rd max_rd mean_tv std_tv min_tv max_tv]];
%     else
        values = [mean_rd std_rd min_rd max_rd mean_tv std_tv min_tv max_tv];
%     end
    
    content{i+1,1} = dataSet;
    for j=1:length(values)
        content{i+1,j+1} = values(j);
    end
%     dlmwrite([pathname filename],
%     dataSet,'delimiter','','roffset',i,'coffset',0);
   
end
% dlmwrite([pathname filename], dataSet, '-append','delimiter','','coffset',0);
% dlmwrite([pathname filename],values,'-append','delimiter',',','coffset',1);
s = xlswrite([pathname filename], content);