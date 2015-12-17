function [data_reshape, data, time_s] = loadStackedTrial(varargin)

switch nargin
    case 2,
        header_location = varargin{1};
        
        if isempty(header_location)
            [filename, pathname] = uigetfile( ...
                {'*.info', 'MATLAB file (*.info)'; ...
                    '*.*',   'All Files (*.*)'}, ...
                     'Pick Time Info');
            
            header_location = fullfile(pathname,filename);
        end    
                
        [pathstr, name, ext, versn] = fileparts(header_location) ;
        
        if strcmp(ext,'.mat')
            S=load(header_location);
            streamInfo.time_ms = S.streamInfo.time_ms;
            clear S;
        elseif strcmp(ext,'.info')
            [streamInfo]=getTimevector(header_location);
        elseif strcmp(ext,'.xml')
            [streamInfo]=zviMetaScanner(header_location);
        end
        
        time_s = streamInfo.time_ms./1000;
        
        
        % get the path of the images
        pathname = varargin{2};
        
        if isempty(pathname)
            pathname = uigetdir([header_location],'Select directory with images');
        end
        
        % get the image file names
        [filenames] = getFilenamesFromDir(pathname,'tif');
        
    otherwise
        error('OIS_RatioAnalysis:WrongNumberOfInputArguments', ...
            'Wrong number of input arguments specified!');
end

frame1 = imread( fullfile( pathname, filenames(1, :) ) );
nFrames = length(filenames);

data = zeros([size(frame1) nFrames],'uint16');
data_reshape = zeros(size(frame1,1)*size(frame1,2),nFrames,'uint16');

for i=1:1:nFrames
   
   frame = imread( fullfile( pathname, filenames(i, :) ) );
   data(:,:,i) = frame;
   data_reshape(:,i) = reshape(frame,size(frame1,1)*size(frame1,2),1);

   
end

% AvgData = double(mean(data,3));
% 
% [BWs, ROIs, numROIs] = selectMultipleROIs(AvgData./4095*255,0);
% 
% h_wait = waitbar(0,'Extracting time course...');
% % extract time course over all slices for each ROI
% for Slice_i = 1:nFrames,
%         
%     FrameData = imread( fullfile( pathname, filenames(Slice_i,:) ) );
% 
%     waitbar(Slice_i/nFrames,h_wait);
%     
%     for m=1:1:numROIs    
%     
%         TimeCourse(m,Slice_i) = mean(FrameData(BWs(:,:,m) == 1));
%     
%     end
% end
% close(h_wait)  
% 
% 
% figure();
% plot(TimeCourse(1,:))
% hold on
% for i = 2:1:numROIs
%     
%     figure();
%     plot(TimeCourse(i,:))
%     
% end
% hold off


end %function


