function [zviInfo] = zviMetaScanner(varargin)

% function for reading some information about a zvi data strea that is
% stored as tif
%
% the tif-folder of each stream contains a file called "_meta.xml"
%
% the time information for each frame is provided in the tag entry V58
%
% this function reads the _meta.xml and extracts the time info as a vector
%
% [zviInfo] = zviMetaScanner()
% [zviInfo] = zviMetaScanner(filename)
%
% info is a struct containing a vector with timestamp for each frame in
%    milliseconds
%
%       zviInfo.time_ms
%       zviInfo.footprint
%
% ---
% Tobias Meyer - 05.2009


% check input parameters
switch nargin
    case 0,
        % get information about the data set
        [filename, pathname] = uigetfile( ...
                {'*.xml', 'xml file (*.xml)'; ...
                    '*.*',   'All Files (*.*)'}, ...
                     'pick meta file');
        fileLocation = [pathname, filename];

    case 1,
        fileLocation = varargin{1};
        
    otherwise
        error('OIS_RatioAnalysis:WrongNumberOfInputArguments', ...
            'Wrong number of input arguments specified!');
end

% open file
FID = fopen(fileLocation,'r');
if (FID == -1),
    error('getOID:FileCouldNotBeOpened',['File: ',zviInfo.dataFileName,...
        ' could not be opened!']);
    status = 0;
    return
end

status = fseek(FID,0,'bof');
if status ~= 0
    disp('error fseek');
    return
end


% time factor for converting the saved time info in milliseconds
timeFactor = 24*60*60*1000;

count = 1;
% scan for general tags ---------------------------------------------------
while 1
    tline{count} = fgetl(FID);
    
    if ~ischar(tline{count})
        break
    end
    
    if strfind(tline{count},'</Tags>')
        break
    end
    
    count = count + 1;
end 
   

for i = 1:1:length(tline)

    if strfind(tline{i},'>519<')
        nFrames = tline{i-1};
    end
    
    if strfind(tline{i},'>515<')
        nCols = tline{i-1};
    end
    
    if strfind(tline{i},'>516<')
        nRows = tline{i-1};
    end

end

idx1 = strfind(nFrames,'>');
idx2 = strfind(nFrames,'<');
zviInfo.nFrames = str2num(nFrames(idx1(1)+1:idx2(end)-1));

idx1 = strfind(nCols,'>');
idx2 = strfind(nCols,'<');
zviInfo.nCols = str2num(nCols(idx1(1)+1:idx2(end)-1));

idx1 = strfind(nRows,'>');
idx2 = strfind(nRows,'<');
zviInfo.nRows = str2num(nRows(idx1(1)+1:idx2(end)-1));


% disp(num2str(zviInfo.nFrames))
% disp(num2str(zviInfo.nCols))
% disp(num2str(zviInfo.nRows))

clear tline;
%--------------------------------------------------------------------------
timeVec=zeros(1,zviInfo.nFrames);

if zviInfo.nFrames > 999
    frameTagString = 't0000';
elseif zviInfo.nFrames < 1000
    frameTagString = 't000';
end

while 1
    buffer = fgetl(FID);

    if strfind(buffer,['<',frameTagString,'>'])
        break
    end
end

buffer = '';
lastbuffer = '';

% scan for frame information
h = waitbar(0,'scan meta file ...');    
for frame_i = 1:1:zviInfo.nFrames;
    
    waitbar(frame_i/(zviInfo.nFrames),h,['scan meta file ... ',num2str(frame_i),'/',num2str(zviInfo.nFrames)])
    
    while 1
        buffer = fgetl(FID);
        
        if strfind(buffer,'>1047</I')
            
            idx1 = strfind(lastbuffer,'>');
            idx2 = strfind(lastbuffer,'<');
            timeVec(frame_i) = str2double(strrep(lastbuffer(idx1(1)+1:idx2(end)-1),',','.'));
            
            break
        end
        
        lastbuffer = buffer;
    end
end
close(h)        

zviInfo.time_ms = (timeVec - timeVec(1)).*timeFactor;
zviInfo.footprint = floor(zviInfo.time_ms/30000);

end % function