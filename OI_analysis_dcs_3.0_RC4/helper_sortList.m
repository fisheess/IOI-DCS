%% sorts dirsToAnalyze-list only
function helper_sortList()
global PARA;

for j=1:length(PARA.dirsToAnalyze)
    field = char(PARA.dirsToAnalyze(j));
    [start ende] = regexp(field,'([0-9]|[1-9][0-9])');
    number = field(min(start):max(ende));
    numbers(j) = str2num(number);
end
numbers = sort(numbers);
for j=1:length(PARA.dirsToAnalyze)
    numberstring = ['s' num2str(numbers(j))];
    for k = 1:length(PARA.subdirs)
       if PARA.subdirs{2,k} && strcmp(PARA.subdirs{1,k},numberstring) && PARA.computed(k)
           numberstring = [numberstring '*'];
           break;
       end
    end
    subdirs_sorted(1,j) = cellstr(numberstring);
end
PARA.dirsToAnalyze(1,:) = subdirs_sorted(1,:);

end % function