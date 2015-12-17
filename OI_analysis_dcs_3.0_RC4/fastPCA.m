D = zeros(size(X_2d));
% center data
for i=1:size(X_2d,1)
    D(i,:) = double(X_2d(i,:) - mean(X_2d(i,:)));
end

[u,S,pc] = svd(D,0);
eigen = diag(S).^2;
pc = pc(:,1:5);
for i=1:5
pc(:,i) = pc(:,i) * sqrt(eigen(i));
end
% eigen = eigen/267;
% S = cov(pc);
figure;plot(t,pc(:,1)-10,'k',t,pc(:,2),'b',t,pc(:,3)+10,'r');