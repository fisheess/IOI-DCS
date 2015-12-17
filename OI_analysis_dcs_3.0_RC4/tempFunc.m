close all
clear p t x tc_t tc_tv;

global DATA PARA;
count = find(PARA.computed);

for i=1:length(cTimecourses)
    timecourse = cTimecourses{i};tc_t = timecourse(:,1);tc_rd=timecourse(:,2);tc_tv = timecourse(:,3);idx_t = find(tc_t > 40);x = tc_tv(idx_t)';t = tc_t(idx_t)';
    [p{1},s] = polyfit(t,x,1);
    [p{2},s] = polyfit(t,x,2);
    [p{3},s] = polyfit(t,x,3);
%     f = polyval(p,y);
%     figure,plot(y,x,'b',y,f,'r'),title(['s',num2str(i),' tvalue']);
    polynoms_tv{i,1} = p;
    
%     polynoms_tv{i,2} = y;
end % for
clear p t x tc_t tc_rd;
for i=1:length(cTimecourses)
    timecourse = cTimecourses{i};tc_t = timecourse(:,1);tc_rd=timecourse(:,2);tc_tv = timecourse(:,3);idx_t = find(tc_t > 40);x = tc_rd(idx_t)';t = tc_t(idx_t)';
%     [p,s] = polyfit(y,x,1);
    [p{1},s] = polyfit(t,x,1);
    [p{2},s] = polyfit(t,x,2);
    [p{3},s] = polyfit(t,x,3);
%     f = polyval(p,y);
%     figure,plot(y,x,'b',y,f,'r'),title(['s',num2str(i),' reldiff']);
    polynoms_rd{i,1} = p;
%     polynoms_rd{i,2} = y;
end % for
clear p t x tc_t tc_mean;
for i=1:length(cTimecourses)
    timecourse = cTimecourses{i};tc_t = timecourse(:,1);tc_rd=timecourse(:,2);tc_tv = timecourse(:,3);
    tc_mean = (tc_rd + tc_tv)./2;
    idx_t = find(tc_t > 40);x = tc_mean(idx_t)';t = tc_t(idx_t)';
%     [p,s] = polyfit(y,x,1);
    [p{1},s] = polyfit(t,x,1);
    [p{2},s] = polyfit(t,x,2);
    [p{3},s] = polyfit(t,x,3);
%     f = polyval(p,y);
%     figure,plot(y,x,'b',y,f,'r'),title(['s',num2str(i),' reldiff']);
    polynoms_mean{i,1} = p;
%     polynoms_rd{i,2} = y;
end % for
% % allocate memory for power image
% % Y = zeros([size(data1,1) size(data1,2)]);
% %  
% % y = [1:size(data1,3)];
% % 
% % for i=1:size(data1,1)
% %     for j=1:size(data1,2)
% %         x=single(data1(i,j,:));
% %         x = x(:)';
% %         [p,s] = polyfit(y,x,1);
% %         power1 = p(1);
% % %         power2 = p(2);
% %         Y4(i,j) = power1;
% % %         Y2(i,j) = power2;
% % %         Y = power1/power2;
% %     end
% % end       
% count = find(PARA.computed);
% 
% for i=1:1:length(count)
%         formFactors{count(i),1} = PARA.subdirs{1,count(i)};
%         formFactors{count(i),2} = determineFormFactors(DATA.mask_tvalues_i{count(i)});
%         formFactors{count(i),3} = determineFormFactors(DATA.mask_reldiff_i{count(i)});
% end;