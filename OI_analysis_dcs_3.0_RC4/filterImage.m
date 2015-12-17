I = im2double(buf);

I_avg = nlfilter(I,[5 5], 'mean2');

F = inline('x(2,2)-sum(x(1:3,1))/3-sum(x(1:3,3))/3-x(1,2)-x(3,2)');
I_diff = nlfilter(I_avg,[3 3],F);

% I_fft = nlfilter(I,[3 3],'fft2');

if min(I_diff(:)) < 0
    I_diff = I_diff - min(I_diff(:));
elseif min(I_avg(:)) < 0
    I_avg = I_avg - min(I_avg(:));
% elseif min(I_fft(:)) < 0
%     I_fft = I_fft - min(I_ff(:));
end

figure;
subplot(3,3,1);
    imshow(I);
    title('Original');
subplot(3,3,2);
    imshow(I_avg);
    title('Averaged');
subplot(3,3,3);
    imshow(I_diff);
    title('Averaged->Differentiated');
 subplot(3,3,4);
    imhist(I_avg);
    title('Averaged - Histogramm');   
subplot(3,3,5);
    imhist(I_diff);
    title('Differentiated - Histogramm');    
% subplot(3,3,6);
%     imshow(I_fft);
%     title('FFT');    
% subplot(3,3,7);
%     imhist(I_fft);
%     title('FFT - Histogramm');    