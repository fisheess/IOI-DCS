%% -- calculate timecourse
function calcTimecourse(nDataSet,bMask)

global DATA PARA PREF;

%get timecourse
DATA.timecourse = zeros(1,PARA.nFrames_binned{nDataSet});

h_wait = waitbar(0,'calculating timecourse ...');
for i=1:PREF.temporalBinning:PARA.nFrames{nDataSet}
   frame = imread([PARA.pathname,'\\', PARA.subdirs{1,nDataSet},'\\',PARA.filenames{nDataSet}(i,:) ]);
   buf = mean(frame(bMask));
%    sta = std(single(frame(DATA.BW)));

   if PREF.temporalBinning == 1
        DATA.timecourse(1,i)=buf;
%         DATA.timecourse(2,i)=buf+sta;
%         DATA.timecourse(3,i)=buf-sta;
   else
        DATA.timecourse(1,floor(i./PREF.temporalBinning )+1)=buf;
%         DATA.timecourse(2,floor(i./PREF.temporalBinning )+1)=buf+sta;
%         DATA.timecourse(3,floor(i./PREF.temporalBinning )+1)=buf-sta;
   end
   
   waitbar(i/PARA.nFrames{nDataSet},h_wait,['calculating timecourse ... ' num2str(uint8(i/PARA.nFrames{nDataSet}*100),'%.0u') '%  (' num2str(i) '/' num2str(PARA.nFrames{nDataSet}) ')'] );
end
close(h_wait);