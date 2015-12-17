function [subdir] = getSubdirFromDir(pathname)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       [subdir] = getSubdirFromDir(pathname)
%
%       pathname ... directory 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files = dir(pathname);

count = 0;
for i = 1:1:length(files)

    if files(i).isdir
        
        if strcmp(files(i).name,'.')
        elseif strcmp(files(i).name,'..')
        elseif strcmp(files(i).name,'rd')
        else
            count = count + 1;
            subdir{count} = files(i).name;
        end
        
    end
end

return