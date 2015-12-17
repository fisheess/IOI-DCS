function VolOut = imcircle(n)

% IMCIRCLE zeichnet einen Kreis aus Einsen in eine Matrix
%	M = IMCIRCLE(D) zeichnet einen Kreis bestehend auf Einsen in eine
%	quadratische Matrix, die im Hntergrund gleich Null ist. Der Durch-
%	messer des Kreises wird in D in Pixeln anegegeben.
%
%	Eingabeparameter:
%	-----------------
%	D          Kreisdurchmesser in Pixeln
%	
%	Ausgabeparameter:
%	-----------------
%	M          quadratische Matrix mit zentralem Kreis = 1, sonst 0
%
%	Zahlenformate:
%	--------------
%	D          ganzzahliger Wert beliebigen Formates
%	M          double Matrix
%
%	Beispiel:
%	---------
%	D = 10;            % Keisdurchmesser = 10 Pixel
%	M = imcircle(D);   % erzeuge Kreis in Matrix
%	disp(M);           % stelle Ergebnis dar
%
%	siehe auch SPHERE3D, SPHERE

% ver0.0.1


if rem(n,1) > 0, 
   disp(sprintf('n is not an integer and has been rounded to %1.0f',round(n)))
   n = round(n);
end

if n < 1     % invalid n
   error('n must be at least 1')
   
elseif n < 4 % trivial n
   VolOut = ones(n);

elseif rem(n,2) == 0,  % even n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   height_45 = round(radius/sqrt(2));
   width = zeros(1,RADIUS);
   semicircle = zeros(DIAMETER,RADIUS);   

   for i  = 1 : height_45
       upward = i - 0.5;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius);
   end

   array = width(1:height_45)-height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   VolOut = [fliplr(semicircle) semicircle];

else   % odd n
   
   DIAMETER = n;
   diameter = n-1;
   RADIUS = DIAMETER/2;
   radius = diameter/2;
   semicircle = zeros(DIAMETER,radius);
   height_45 = round(radius/sqrt(2) - 0.5);
   width = zeros(1,radius);

   for i  = 1 : height_45
       upward = i;
       sine = upward/radius;
       cosine = sqrt(1-sine^2);
       width(i) = ceil(cosine * radius - 0.5);
   end

   array = width(1:height_45) - height_45;

   for j = max(array):-1:min(array)
       width(height_45 + j) = max(find(array == j));
   end

   if min(width) == 0
      index = find(width == 0);
      width(index) = round(mean([width(index-1) width(index+1)]));
   end

   width = [fliplr(width) max(width) width];

   for k  = 1 : DIAMETER
       semicircle(k,1:width(k)) = ones(1,width(k));
   end   

   VolOut = [fliplr(semicircle) ones(DIAMETER,1) semicircle];

end
