function noise = spatialNoise(I,type)

[nRows, nCols] = size(I);

if type == 0 % no noise
    noise = zeros(nRows, nCols);
elseif type == 1 % gaussian noise
    noise = 50 * randn(nRows,nCols); % mean + SD*randn()
elseif type == 2 %poisson noise
    noise = imnoise(I,'poisson');
else
    error('wrong noise type');
end

end %function