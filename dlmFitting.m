
path='D:\Dropbox\DA\Matlab\IOI-DCS\';
% load data
load([path 'timeCourses.mat']);

t = tc{1}(:,1);
y = tc{1}(:,2); 

% state and observation matrix
opt = struct('trig',2,'order',1);
[G,F] = dlmgensys(opt);

% scale y for numerical stability
ys = stdnan(y);
yy = y./ys;

%
ym = meannan(yy); % mean observations
wtrend = abs(ym)*0.005/12; % trend std
wseas = 0.01;% seasonal component std
w0 = [0 wtrend wseas wseas wseas wseas];

%
opt = struct('trig',2,'mcmc',1,'nsimu',2000);
opt.winds = [0 1 2 2 2 2];
opt.varcv = [1 1];
dlm = dlmfit(yy,122,w0,[],[],[],opt);