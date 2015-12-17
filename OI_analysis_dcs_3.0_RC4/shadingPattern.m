function out = shadingPattern(I,type)

[nRows, nCols] = size(I);


if type == 0 % no shading
    out = ones(nRows,nCols);
    
elseif type == 1 % centered gaussian shading
    out = fspecial('gaussian',nRows,nRows .* 0.4);
    out = imresize(out,[nRows, nCols]);
    out = out ./ max(out(:));
    
elseif type == 2 % shading pattern from pico
    A = load('shading_pico.mat');
    out = A.shading_pico;
    out = imresize(out,[nRows, nCols]);
    
else
    error('wrong type');
end





end %function