%% export all formfactors to xls
function exportFormFactors2xls(fileext,formFactors,type)

global PARA;
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
switch type
    case 'tvalues'
        nType = 2;
    case 'reldiff'
        nType = 3;
    otherwise
        error('Unknown type!');
end
% find patient name
ind=regexp(PARA.pathname,'p\d{3}');
string=[PARA.pathname(ind:ind+3)];

pathname = 'C:\Users\IBMT\Desktop\';
filename =  [string fileext];
% [filename, pathname] = uiputfile(['E:\wahl\Diplomarbeit\Auswertung\' string fileext],'Save as...');

% try
    if csv
        title = ['Dataset,MeanRD,StdRD,MinRD,MaxRD,MeanTV,StdTV,MinTV,MaxTV'];
        dlmwrite([pathname filename],title,'delimiter','','newline','pc');
    else
         content = {'Dataset','Area','Perimeter','Distance','Extent','Solidity','Max','Min','Mean','Std'};
    end

    % put statistic data to file
    for i=1:length(count)

        formFactor = formFactors{count(i),nType};
        content{count(i)+1,1} = strrep(formFactors{count(i),1},'s',''); % remove trailing 's' from dataset
        content{count(i)+1,2} = formFactor.Area;
        content{count(i)+1,3} = formFactor.Perimeter;      
        content{count(i)+1,4} = formFactor.Distance;      
        content{count(i)+1,5} = formFactor.Extent;      
        content{count(i)+1,6} = formFactor.Solidity;        
        content{count(i)+1,7} = formFactor.Max;
        content{count(i)+1,8} = formFactor.Min;
        content{count(i)+1,9} = formFactor.Mean;
        content{count(i)+1,10} = formFactor.Std;
        s = xlswrite([pathname filename], content, [type '_formfactors']);

    end % for

    if csv
       msgbox(['Successfully exported to ' filename '!'],'Export');
    else
%         s = xlswrite([pathname filename], content,type);
        if s
%             msgbox(['Successfully exported to ' filename '!'],'Export');
        else
            errordlg(['Could not export to ' filename '!']);
        end
    end
% catch
%     errordlg(['Could not export to ' filename '!']);
% end