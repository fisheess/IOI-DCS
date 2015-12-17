function  xlsExport(fileext)

global DATA PARA;
csv = false;
if ~isempty(fileext) && strcmp(fileext,'.csv')
    csv = true;
elseif ~isempty(fileext) && ~strcmp(fileext,'.csv')
     errordlg('Unknown file extension!');
     return
end

count = find(PARA.computed);
% find patient name
ind=strfind(PARA.pathname,'\');
pos=ind(end)+1;
string=PARA.pathname(pos:end);

% add analysed datasets
for i=1:length(count)
    string = [string '_' PARA.subdirs{1,count(i)}];  
end

[filename, pathname] = uiputfile([string fileext],'Save as...');

try
    if csv
        title = ['Dataset,MeanRD,StdRD,MinRD,MaxRD,MeanTV,StdTV,MinTV,MaxTV'];
        dlmwrite([pathname filename],title,'delimiter','','newline','pc');
    else
        content = {'Dataset','MeanRD','StdRD', 'MinRD', 'MaxRD', 'MeanTV','StdTV', 'MinTV', 'MaxTV'};    
        values = 0;
    end

    % put statistic data to file
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

        if csv % convert numericals to string and seperate them manually by commata
             line = [dataSet ',' num2str(mean_rd) ',' num2str(std_rd) ',' num2str(min_rd) ',' num2str(max_rd) ',' num2str(mean_tv) ',' num2str(std_tv) ',' num2str(min_tv) ',' num2str(max_tv)];
             dlmwrite([pathname filename], line ,'-append','delimiter','');
        else % save values and dataset-string in cells
            values = [mean_rd std_rd min_rd max_rd mean_tv std_tv min_tv max_tv];
            content{i+1,1} = dataSet;
            for j=1:length(values)
                content{i+1,j+1} = values(j);
            end
        end

    end

    if csv
       msgbox(['Successfully exported to ' filename '!'],'Export');
    else
        s = xlswrite([pathname filename], content);
        if s
            msgbox(['Successfully exported to ' filename '!'],'Export');
        else
            errordlg(['Could not export to ' filename '!']);
        end
    end
catch
    errordlg(['Could not export to ' filename '!']);
end