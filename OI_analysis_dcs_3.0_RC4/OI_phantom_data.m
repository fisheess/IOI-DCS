% script for generation of artifical optical imaging data
% ---
% Tobias Meyer - 06.2011
function OI_phantom_data (varargin)

% if nargin == 0,
%   error ('No input arguments.');
% end

%% default parameter
savePathname = '.\phantom_data_01';
nResponses = 3;
% for i=1:1:nResponses
%  spatialResponsePattern{i} = logical(zeros(520,692));
% end % for

stimulusBlockLength_s = 30;
baselineBlockLength_s = 30;
nTrials = 9;
% nTrials = 1;

nSpatialNoiseType = 0;   
nSpatialNoiseMultiplier = 10;
nShadingPatternType = 0;

nTrendFactor = 0;
nHeartbeatFactor   = 0;
nRespirationFactor = 0;
nNoiseFactor = 0;

nAmplitude = -100; 
nAmplitudeIncrement = 0;
nAmplitudeType = 1;

%% read optional parameter
if (rem(length(varargin),2)==1)
  error('Optional parameters should always go by pairs');
else
  for i=1:2:(length(varargin)-1)
    if ~ischar (varargin{i}),
      error (['Unknown type of optional parameter name (parameter' ...
	      ' names must be strings).']);
    end % if
    % change the value of parameter
    switch varargin{i}
        case 'path'
            savePathname = lower (varargin{i+1});
        case 'responses'
            nResponses = varargin{i+1};
        case 'spatialNoiseType'
            nSpatialNoiseType = varargin{i+1};
        case 'spatialNoiseMultiplier'
            nSpatialNoiseMultiplier = varargin{i+1};
        case 'shadingPatternType'
            nShadingPatternType = varargin{i+1};
        case 'trend'
            nTrendFactor = varargin{i+1};
        case 'heartbeat'
            nHeartbeatFactor = varargin{i+1};
        case 'respiration'
            nRespirationFactor = varargin{i+1};
        case 'noise'
            nNoiseFactor = varargin{i+1};
        case 'amplitude'
            nAmplitude  = varargin{i+1};
        case 'amplitudeIncrement'
            nAmplitudeIncrement  = varargin{i+1};
        case 'amplitudeType'
            nAmplitudeType = varargin{i+1};          
        case 'baseLength'
            baselineBlockLength_s = varargin{i+1};
        case 'stimLength'
            stimulusBlockLength_s = varargin{i+1};
        case 'trials' 
            nTrials = varargin{i+1};
        otherwise
         % Hmmm, something wrong with the parameter string
            error(['Unrecognized parameter: ''' varargin{i} '''']);
     end; % switch
  end; % for
end % if

%% outputpath
if ~exist(savePathname)
    mkdir(savePathname)
end

%% create background image
background = uint16(400.*ones(520,692));
background(1:10,1:10) = 4095;
%background(:,101:200) = 500;
%background(:,201:300) = 1000;
%background(:,301:400) = 1500;
%background(:,401:500) = 2000;
%background(:,501:600) = 2500;
background = imnoise(background,'poisson');

%% add trepanation to background
trepanation = logical(imread('trepanation_ellipse.tif'));
background(trepanation) = 2500;

%% create spatial response pattern
% spatialResponsePattern = logical(zeros(520,692));
%spatialResponsePattern(211:310,51:650) = 1;
radius = 50;
circ = logical(imcircle(2*radius+1)); %diameter
center = [260 346];

% % s1
% spatialResponsePattern{1}( center(1) - radius : center(1) + radius,center(2) - radius : center(2) + radius ) = circ;
% % s2
% spatialResponsePattern{2}( 250-radius:250+radius, 400-radius:400+radius )=circ;
% % s3
% spatialResponsePattern{3}( 300-radius:300+radius, 100-radius:100+radius ) =circ;

x = [280 400 280 400 280 400];
y = [140 140 260 260 380 380]; 

for i=1:1:nResponses
    spatialResponsePattern{i} = logical(zeros(520,692));
    if length(x) >= i
        x_i = x(i);
        y_i = y(i);
    elseif (length(x) < i) && (i < 2*length(x))
        x_i = x( 2*length(x)-i );
        y_i = y( i-length(y) );
    end % if
    spatialResponsePattern{i}(y_i-radius:y_i+radius, x_i-radius:x_i+radius) =circ;    
end % for

% spatialResponsePattern( 335-radius:420+radius, 542-radius:542+radius ) = circ;
% spatialResponsePattern( 260-radius:260+radius, 346-radius:346+radius ) =
% circ;

%% spatial noise
% spatialNoiseType = 1;   % 0 ... no spatial noise
%                         % 1 ... normal distributed noise
%                         % 2 ... poisson distributed noise
% % multiplier for trepanation                        
% spatialNoiseMultiplier = 10;
                        
%% create shading
% shadingPatternType = 2; % 0 ... no shading
                        % 1 ... use centered gaussian shading
                        % 2 ... use pico shading
                        
I_shadingPattern = shadingPattern(background,nShadingPatternType);

%% create temporal response pattern

% stimulusBlockLength_s = 30;
% baselineBlockLength_s = 30;
% % nTrials = 9;
% nTrials = 1;

timeLength_s = nTrials * (stimulusBlockLength_s + baselineBlockLength_s);

% time vector
time_s = 0:0.2:timeLength_s;

% temporal response pattern
[temporalResponsePattern] = fMRI_response(time_s, stimulusBlockLength_s, baselineBlockLength_s, nTrials );
%temporalResponsePattern = zeros(size(time_s));
%temporalResponsePattern(length(temporalResponsePattern)/2:end) = 1;

%% create temporal drift and fluctuations

% trend
trend = -nTrendFactor/timeLength_s * time_s;

% heartbeat and respiration
heartbeat   = nHeartbeatFactor .* sin(2*pi * 55/60 * time_s); % 55 beats per minute
respiration = nRespirationFactor .* sin(2*pi * 12/60 * time_s); % 12 per minute

% add noise to response pattern
noise = nNoiseFactor * randn(size(time_s));

temporalFluctuations = trend + heartbeat + respiration + noise;

%% set up amplitude of temporal signal
amplitude(1:nResponses) = nAmplitude;
for i=1:1:nResponses
    amplitude(i) =  nAmplitude + (i-1)*nAmplitudeIncrement;
end % for

% amplitude = -100; % in gray values
% amplitudeType = 1;  % 0 ... absolut
%                     % 1 ... relativ to background gray value

%% plot out the parameters                    
% figure;
% subplot(2,3,1)
% imshow(background,[0 4095]);
% 
% subplot(2,3,2)
% imshow(I_shadingPattern,[0 1]);
% 
% subplot(2,3,3)
% imshow(spatialResponsePattern);
% 
% subplot(2,3,4)
% plot(time_s, temporalFluctuations);
% hold on; 
% set(gca,'XLim',[0 timeLength_s]); 
% %set(gca,'YLim',[]); 
% hold off
% 
% subplot(2,3,6)
% plot(time_s, temporalResponsePattern);
% hold on;
% set(gca,'XLim',[0 timeLength_s]);
% set(gca,'YLim',[-0.1 1.1]); 
% hold off

% return
                    
%% generate data
generateData(   background,...
                trepanation,...
                spatialResponsePattern,...
                nSpatialNoiseType,...
                nSpatialNoiseMultiplier,...
                I_shadingPattern,...
                temporalResponsePattern,...
                temporalFluctuations,...
                time_s,...
                amplitude,...
                nAmplitudeType,...
                savePathname);
end % function