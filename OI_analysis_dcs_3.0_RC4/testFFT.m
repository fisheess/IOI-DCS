global DATA PARA;
tic
i = PARA.showCurrDataSet;

for j = 1:length(PARA.filenames{i})

    data(:,:,j) = imread([PARA.pathname,'\', PARA.subdirs{1,i},'\',PARA.filenames{i}(j,:) ]);

end

 time_s = DATA.time_s{i};
% time_s = info.time_mes./1000;
idx_t = [find(time_s < 20) find(time_s >40)];
idx_corr = [find(time_s < 20) find(time_s >40 & time_s <60)];
% idx_t = [find(time_s >40 & time_s <120)];
% time(idx_t) = time_s(idx_t);
time = time_s(idx_t);
time_corr = time_s(idx_corr);
% for i = 1:size(idx_t,2)
data_fft = data(:,:,idx_t);
data_corr = data(:,:,idx_corr);

%% fft
% end
% create frequency vector
f_Hz = (1/mean(diff(time))) * (0 : size(idx_t,2)-1) ./size(idx_t,2); 

stimFreq = 1/max(time_s);
%minFreq = 0.5 .* stimFreq;
maxFreq = 0.1;
%maxFreq = 2 .* stimFreq;

% FreqL = 0.1 .* stimFreq;
% FreqH = 10 .* stimFreq;
FreqL = min(f_Hz);
FreqH = max(f_Hz);

i=1;
% while ((f_Hz(i) < minFreq)&&(i < max(size(f_Hz))))
%         i = i+1; 
% end
idxMinFreq = 2;

while ((f_Hz(i) < maxFreq)&&(i < max(size(f_Hz))))
    i = i+1; 
end
idxMaxFreq = i;

i=1;
while ((f_Hz(i) < FreqL)&&(i < max(size(f_Hz))))
        i = i+1; 
end
idxFreqL = i;

while ((f_Hz(i) < FreqH)&&(i < max(size(f_Hz))))
    i = i+1; 
end
idxFreqH = i;

i=1;
while ((f_Hz(i) < 0.1)&&(i < max(size(f_Hz))))
        i = i+1; 
end
idxFreq01 = i;

% allocate memory for power image
Y = zeros([size(data,1) size(data,2)]);
 
% x^1
% y1 = (0.3775 .* time )'; %stark 120s
% y2 = (0.6515 .* time )'; %mittel 120s
% y3 = (0.4058 .* time)'; %schwach 120s

y1 = (-0.5059 .* time_corr )'; %stark 60s
% y2 = (-0.5022 .* time )'; %mittel 60s
% y1 = (0.2241 .* time)'; %schwach 60s
% % x^2
% y1 = 0.0141 .* time.^2 - 1.8722.* time; % stark 120s 
% y2 = 0.0082.* time.^2 - 0.6541.* time ; %mittel x120s
% y3 = -0.0048.* time.^2 + 1.1779.* time ; %schwach 120s

for i=1:size(data,1)
    for j=1:size(data,2)
        x=[];
        x=single(data_fft(i,j,:));
        x = x(:)';
%         [Pxx] = pwelch(x);
        F = abs(fft(x));
        P = abs(F./(length(idx_t)./2)).^2;
        power1 = sum(P(idxMinFreq:idxMaxFreq));
% %         power1 = sum(F(1));
        power2 = sum(P(2:idxFreqH)/2);
        Y(i,j) = power1./power2;
%         p = polyfit(time,x,1);
        x = [];
        x=single(data_corr(i,j,:));
        x = x(:)';
        R1= corrcoef(x',y1);
% %         R2= corrcoef(x',y2);
% %         R3= corrcoef(x',y3);
        X1(i,j) = R1(1,2);
%         X2(i,j) = abs(R2(1,2));
%         X3(i,j) = abs(R3(1,2));
%         X1(i,j) = p(1)/abs(R1(1,2));
%         X2(i,j) = p(1)/abs(R2(1,2));
%         X3(i,j) = p(1)/abs(R3(1,2));
%         Y = fft(x);
    end
end 

trepanation = DATA.trepanationMask{PARA.showCurrDataSet};
figure,imshow(imrotate(imfilter(Y,DATA.smoothFilter),180));colormap jet;hold on; contour(trepanation,'r')
figure,imshow(imrotate(imfilter(X1,DATA.smoothFilter),180));colormap jet;hold on; contour(trepanation,'r')
% figure,imshow(imrotate(imfilter(X2,fspecial('gaussian',5,5*0.1213)),180));colormap jet;hold on; contour(trepanation,'r')
% figure,imshow(imrotate(imfilter(X3,fspecial('gaussian',5,5*0.1213)),180));colormap jet;hold on; contour(trepanation,'r')
toc
%% anstiege
% x^1
% y = (0.3775 .* time )'; %stark 120s
% y = (0.6515 .* time )'; %mittel 120s
% y = (0.4058.* time)'; %schwach 120s

% y1 = (-0.5059 .* time )'; %stark 60s
% y2 = (-0.5022 .* time )'; %mittel 60s
% y3 = (0.2241 .* time)'; %schwach 60s
% % x^2
% y1 = 0.0141 .* time.^2 - 1.8722.* time; % stark 120s 
% y2 = 0.0082.* time.^2 - 0.6541.* time ; %mittel x120s
% y3 = -0.0048.* time.^2 + 1.1779.* time ; %schwach 120s

% tic
% % X = zeros([size(data,1) size(data,2)]);
% % Z = zeros([size(data,1) size(data,2)]);
% for i=1:size(data,1)
%     for j=1:size(data,2)
%         x=single(data_fft(i,j,:));
%         x = x(:)';
% %         p = polyfit(time,x,1);
%         R1= corrcoef(x',y1);
%         R2= corrcoef(x',y2);
%         R3= corrcoef(x',y3);
%         X1(i,j) = abs(R1(1,2));
%         X2(i,j) = abs(R2(1,2));
%         X3(i,j) = abs(R3(1,2));
% %         Z(i,j) = p(1);
% %         Y = fft(x);
%     end
% end




% figure,imshow(imrotate(Z,180));
% colormap jet;
%         buffer = handles.data(i,j,:);
%         buffer = double(buffer(:)');
%         
%         F = abs(fft(buffer, handles.nDataPoints_binned));
% 
%         power1 = sum(F(idxMinFreq:idxMaxFreq));
%         power2 = sum(F(idxFreqL:idxFreqH));
%         
%         handles.powerImage(i,j) = power1./power2;
