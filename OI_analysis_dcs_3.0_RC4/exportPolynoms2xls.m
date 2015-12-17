%% export all timecourses in xls
function exportPolynoms2xls(fileext,polynoms,type)

global DATA PARA;
warning off MATLAB:xlswrite:AddSheet

if ~isempty(fileext) && strcmp(fileext,'.csv')
    csv = true;
elseif ~isempty(fileext) && strcmp(fileext,'.xls')
    csv = false;
elseif ~isempty(fileext) && ( ~strcmp(fileext,'.csv') || ~strcmp(fileext,'.xls') )
     errordlg('Unknown file extension!');
     return
end % if

count = find(PARA.computed);
% find patient name
ind=regexp(PARA.pathname,'p\d{3}');
string=PARA.pathname(ind:ind+3);

% add analysed datasets
% for i=1:length(count)
%     string = [string '_' PARA.subdirs{1,count(i)}];  
% end % for
pathname = 'E:\wahl\Diplomarbeit\Auswertung\';
filename =  [string fileext];
% [filename, pathname] = uiputfile(['E:\wahl\Diplomarbeit\Auswertung\' string fileext],'Save as...');

% try
    if csv
        title = ['Dataset,MeanRD,StdRD,MinRD,MaxRD,MeanTV,StdTV,MinTV,MaxTV'];
        dlmwrite([pathname filename],title,'delimiter','','newline','pc');
    else
%      content = {'Dataset','x^2','x^1','x^0'};
     content = {'Dataset','x^1','x^0','x^2','x^1','x^0','x^3','x^2','x^1','x^0'};
     values = 0;
    end

    % put statistic data to file
    for i=1:length(count)

        dataSet = PARA.subdirs{1,count(i)};
        polynom = polynoms{i,1};
        values = [];
%         if csv % convert numericals to string and seperate them manually by commata
%              line = [dataSet ',' num2str(mean_rd) ',' num2str(std_rd) ',' num2str(min_rd) ',' num2str(max_rd) ',' num2str(mean_tv) ',' num2str(std_tv) ',' num2str(min_tv) ',' num2str(max_tv)];
%              dlmwrite([pathname filename], line ,'-append','delimiter','');
%         else % save values and dataset-string in cells
        content{i+1,1} = dataSet;
        for k = 1:length(polynom)
            values = [values polynom{1,k}];
        end
        for j=1:length(values)
            content{i+1,j+1} = values(j);
        end
%         end

    end

    if csv
       msgbox(['Successfully exported to ' filename '!'],'Export');
    else
        s = xlswrite([pathname filename], content,type);
        if s
%             msgbox(['Successfully exported to ' filename '!'],'Export');
        else
            errordlg(['Could not export to ' filename '!']);
        end
    end
% catch
%     errordlg(['Could not export to ' filename '!']);
% end