I = imread('eight.tif');

figure, imshow(I); hold on


% these are the vertices for the mask

c = [222 272 300 270 221 194];
r = [20 21 75 121 121 75];

% adding 1st element of original list to the end

c = [c c(1)] 
r = [r r(1)]

% plot a graph with axes c and r
% style the lines as solid and in black
% use star marks

plot(c,r,'*b-');

% roipoly: returns region of interest specified by c and r vectors
% returns a binary image with the selected region

binary = roipoly(I,c,r);

figure; imshow(binary);

% product + type conversion

ImCrp = I .* uint8(binary);

figure; imshow(ImCrp);

imgFinal = binary.*(double(I));

figure; imagesc(imgFinal); colormap gray