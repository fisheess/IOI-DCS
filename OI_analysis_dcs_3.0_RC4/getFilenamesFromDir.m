function [filenames] = getFilenamesFromDir(pathname, ext)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       [Filenames] = getFilenamesFromDir(pathname, ext)
%
%       pathname ... directory where files are stored
%       ext      ... extension of filetype (e.g. 'tif')
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files = dir(pathname);

count = 0;
for i = 1:1:length(files)

    if ~files(i).isdir
        
        if ~isempty( findstr(files(i).name,['.',ext]))
            count = count + 1;
            filenames(count,:) = files(i).name;
        end
    end
end

return

