%% Check specified directory in handles.pathname for new subdirs
function watchDirectory(timer,event)
% hObject was stored in timer
hObject = get(timer,'UserData');
% get current handle via guidata-call
handles = guidata(hObject);
% get current directory tree
watchDir = folderSizeTree(handles.pathname);
% get stored directory tree
dir = handles.subdirProperties;

% check if any subfolders were added or removed
if length(dir.name) ~= length(watchDir.name)
    
        handles.subdirs = getSubdirFromDir(handles.pathname);
    
    for i = 1:1:size(handles.subdirs,2)
        % get the image file names
        f = getFilenamesFromDir([handles.pathname,'\\',handles.subdirs{1,i}],'tif');
        handles.filenames{i} = f;
        
        % get the time info
        [info] = getTimevector([handles.pathname,'\', handles.subdirs{1,i},'\','time.info']);
        
        handles.time_s{i} = info.time_ms./1000;
        handles.time_s_binned{i} = handles.time_s{i}(1:handles.tempbin:end);
        
        handles.nFrames{i} = length(info.time_ms);
        handles.nFrames_binned{i} = ceil(handles.nFrames{i}./handles.tempbin);
        
        handles.nDataPoints{i} = handles.nFrames{i};
        handles.nDataPoints_binned{i} = ceil(handles.nFrames{i}./handles.tempbin);
        
        handles.subdirs{2,i} = 0;
        
    end
    % save new properties
    handles.subdirProperties = watchDir;
    % update list box
    set(handles.lb_subdir,'String',handles.subdirs(1,:));
end

guidata(hObject, handles);