%% export all timecourses in xls
function cTimecourses = exportTC2xls(fileext)

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
% ind=strfind(PARA.pathname,'\');
% pos=ind(end-1)+1;
% string=PARA.pathname(pos:pos+3);
ind=regexp(PARA.pathname,'p\d{3}');
string=PARA.pathname(ind:ind+3);
% add analysed datasets
% for i=1:length(count)
%     string = [string '_' PARA.subdirs{1,count(i)}];  
% end % for
pathname = 'C:\Users\IBMT\Desktop\';
filename =  [string fileext];
% [filename, pathname] = uiputfile(['E:\wahl\Diplomarbeit\Auswertung\' string fileext],'Save as...');

% try
    if csv
        title = ['Dataset,Time,Grayvalues'];
        dlmwrite([pathname filename],title,'delimiter','','newline','pc');
    else
        content = {'Time','Grayvalues'};    
        values = [];
    end % if

    % put statistic data to file
    for i=1:length(count)
        
        content = {'Time','GW reldiff','GW tvalue', 'Mean'};    
        values = [];
        timecourse = [];
        k = 1; %semaphore
        
        dataSet = PARA.subdirs{1,count(i)};
        time = (DATA.time_s{1,count(i)})';
        for l =1:length(count)
            masks{1,l} = DATA.BW{count(l)};
            masks{2,l} = DATA.BW{count(l)};
        end % for
        if k == 1 
            calcTimecourse(count(i),masks{k,i});
            timecourse(:,k) = DATA.timecourse;
%             [t{count(i),1} t{count(i),2}] = getCurveparameters(smooth(timecourse(:,k)),count(i));
            k=k+1;
        end
        if k == 2
%             stats = regionprops(double(masks{k,i}),'ConvexImage');
%             calcTimecourse(count(i),masks{k,i});
%                 stats = regionprops(double(masks{k,i}),'ConvexImage','BoundingBox');
%                 for j = 1:stats.BoundingBox(4)
%                     for l = 1:stats.BoundingBox(3)
%                         masks{k,i}(round(stats.BoundingBox(2))+j,round(stats.BoundingBox(1))+l) = stats.ConvexImage(j,l);
%                     end
%                 end
            calcTimecourse(count(i),masks{k,i});
            timecourse(:,k) = DATA.timecourse;
            [t{count(i),1} t{count(i),2}] = getCurveParameters(smooth(timecourse(:,k)),count(i));
        end

        if csv % convert numericals to string and seperate them manually by commata
             line = [dataSet ',' num2str(mean_rd) ',' num2str(std_rd) ',' num2str(min_rd) ',' num2str(max_rd) ',' num2str(mean_tv) ',' num2str(std_tv) ',' num2str(min_tv) ',' num2str(max_tv)];
             dlmwrite([pathname filename], line ,'-append','delimiter','');
        else % save values and dataset-string in cells
            values = [time timecourse];
            cTimecourses{i} = values;
%             content{i+1,1} = dataSet;
            for j=2:length(values)
                content{j,1} = values(j,1);
                content{j,2} = values(j,2);
                content{j,3} = values(j,3);
                content{j,4} = (values(j,3)+values(j,2) )./2;
            end % for
        end % if
        s = xlswrite([pathname filename], content, dataSet);               
    end % for
% save curveparameters for tvalue
    content = {'DataSet', 'PrS_s', 'PoS_s', 'Min_s', 'PoS2_s', 'PrS2_s'};
%     for i = 1:length(DATA.time_s)
%        content{i+1,1} = [];
%        content{i+1,2} = [];
%        content{i+1,3} = [];
%        content{i+1,4} = [];
%        content{i+1,5} = [];
%        content{i+1,6} = [];
%     end
    for i = 1:length(count)
       content{count(i)+1,1} = PARA.subdirs{1,count(i)};
       content{count(i)+1,2} = t{count(i),1}.PrS_s;
       content{count(i)+1,3} = t{count(i),1}.PoS_s;
       content{count(i)+1,4} = t{count(i),1}.Min_s;
       content{count(i)+1,5} = t{count(i),1}.PoS2_s;
       content{count(i)+1,6} = t{count(i),1}.PrS2_s;
       s = xlswrite([pathname filename], content, 'CP');
   end
    
    if csv
       msgbox(['Successfully exported to ' filename '!'],'Export');
    else
%         s = xlswrite([pathname filename], content);
        if s
%             msgbox(['Successfully exported to ' filename '!'],'Export');
        else
            errordlg(['Could not export to ' filename '!']);
        end % if
    end % if
% catch
%     errordlg(['Could not export to ' filename '!']);
% end % try