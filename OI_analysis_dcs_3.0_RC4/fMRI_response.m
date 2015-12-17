function [s] = fMRI_response(t, stimulusBlockLength_s, baselineBlockLength_s, nTrials)
% fmri response according to Purdon2001

% parameter
d_a = 3;
d_b = 10;

D = 0;

f_a = 1; %flow response
f_b = -0.9; %volume response
f_c = 0.2; %interaction


% stimulus vector
c = zeros(size(t));
    
for i = 1:1:nTrials
    c(find( t >= (i-1)*(baselineBlockLength_s + stimulusBlockLength_s) & t < ((i-1)*(baselineBlockLength_s + stimulusBlockLength_s) + baselineBlockLength_s) )) = 0; %2*(i-1);
    c(find( t >= ((i-1)*(baselineBlockLength_s + stimulusBlockLength_s) + baselineBlockLength_s) & t < ((i)*(baselineBlockLength_s + stimulusBlockLength_s))))  = 1; %2*i-1;
end


g_a = ( 1 - exp( -(1./d_a) ) ).^2.*( (t - D) + 1 ).*exp( -(t - D) ./ d_a );
g_b = ( 1 - exp( -(1./d_b) ) ).^2.*exp( -(t-D)./d_b );

s = f_a .* conv(g_a,c) + f_b .* conv(g_b,c) + f_c .* conv(g_a,c) .* conv(g_b,c);

s = s(1:length(t))./max(s);

% TODO: add some noise



% figure;
% plot(t,s,'LineWidth',2);
% hold on;
% plot(t,c,'--','Color','m');
% hold off

end %function