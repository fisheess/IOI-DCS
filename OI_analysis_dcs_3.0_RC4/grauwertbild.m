x = 1680;
y = 1050;

graylvl = 1000;

image = zeros(y,x);

steplength = floor(x/graylvl);
gv=[0:graylvl/(x/steplength):graylvl];

j = 1;

for i = 1:steplength:x
    if i+steplength-1 > x
        i = i-steplength;
        image(:,i:end) = gv(j-1);
        break;
    end
    image(:,i:i+steplength) = gv(j);
    j = j + 1;
end

figure,imshow(image,[0 graylvl-1]);

    
    
