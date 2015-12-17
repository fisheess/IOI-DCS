function [sp,f,t] = spectog(x,nfft,fs,noverlap)

[N xcol] = size(x);
if N < xcol
    x = x';
    N = xcol;
end
incr = nfft-noverlap;
hwin = fix(nfft/2);
f = (1:hwin)*(fs/nfft);

x_mod = [zeros(hwin,1); x; zeros(hwin,1)];

j = 1;

for i = 1:incr:N
    data = x_mod(i:i+nfft-1) .* hanning(nfft);
    ft = abs(fft(data));
    sp(:,j) = ft(1:hwin);
    t(j) = i/fs;
    
    j = j + 1;
end
