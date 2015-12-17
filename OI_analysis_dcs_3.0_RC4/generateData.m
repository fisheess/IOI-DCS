function generateData( I, trepanation,spatialResponsePattern,...
                        spatialNoiseType, spatialNoiseMultiplier,...
                        I_shadingPattern, temporalResponsePattern,...
                        temporalFluctuations, time,...
                        amplitude,amplitudeType,...
                        savePathname  )

I = double(I);
h = waitbar(0,'Writing frames...');
for j=1:1:length(spatialResponsePattern)
    path = [savePathname,'\s',num2str(j),'\'];
    if ~exist(path)
        mkdir(path);
    end
    for i = 1:1:length(time)
        waitbar(i/length(time),h)

        buf = I;

        if amplitudeType == 0 % absolut
            buf(spatialResponsePattern{j}) = buf(spatialResponsePattern{j}) + (amplitude(j)) .* temporalResponsePattern(i);
        elseif amplitudeType == 1 %relative
            buf(spatialResponsePattern{j}) = buf(spatialResponsePattern{j})+ (buf(spatialResponsePattern{j}) .* (amplitude(j) .* temporalResponsePattern(i) ./ 4095));      
        else
            error('wrong amplitude type');
        end

        buf(trepanation) = buf(trepanation) + temporalFluctuations(i)+ spatialNoiseMultiplier.*spatialNoise(buf(trepanation),spatialNoiseType);

        % add spatial noise
        buf = buf + spatialNoise(buf,spatialNoiseType);

        % add shading
        buf = buf .* I_shadingPattern;

        % write frame to disc
        filename = 't00000';
        filename(1,(length(filename)-length(num2str(i))+1):length(filename)) = num2str(i);
        buf = buf./4096.*256;
        imwrite(uint8(round(buf)),[path,filename,'.png']);
    waitbar(i/length(time),h,['Writing frames ... ' num2str(uint8(i/length(time)*100),'%.0u') '%  (Dataset ' num2str(j) '/' num2str(length(spatialResponsePattern)) ')'] );
    end % for



    % write time vector in milli seconds
    M = 1:1:length(time);
    M = M';

    M(:,2) = 1000*time';

    dlmwrite([path,'\time.info'],M,';');
end % for
close(h);
end % function