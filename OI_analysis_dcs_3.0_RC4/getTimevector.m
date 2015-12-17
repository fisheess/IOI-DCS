function [info] = getTimevector(varargin)

% read the time information from the cvs-file 
%
% [info] = getTimevector()
% [info] = getTimevector(filename)
%
% -------------------------------------------------------------------------
% Tobias Meyer - 21.10.2008

switch nargin
    case 0,
        % get information about the data set
        [filename, pathname] = uigetfile( ...
                {'*.info', 'MATLAB file (*.info)'; ...
                    '*.*',   'All Files (*.*)'}, ...
                     'Pick Time Info');
        location = [pathname, filename];

    case 1,
        location = varargin{1};
        
    otherwise
        error('getTimevector:WrongNumberOfInputArguments', ...
            'Wrong number of input arguments specified!');
end
%--------------------------------------------------------------------------

buffer = dlmread(location,';');

if ~buffer(1,1)
    info.bit = buffer(1,2);
    buffer(1,:) = [];
else
    info.bit = 12;
end

info.time_ms = buffer(:,2) - buffer(1,2);

info.time_ms = info.time_ms';

Footprint = floor(info.time_ms/15000);
info.footprint = Footprint;

end % function