clear all, close all

img = imgread('veiculoGray.jpg');

imageN = imnoise(img, 'salt & pepper', 0.42);
figure;imshow(imageN);
imageF2 = medfilt2(imageN);
figure, imshow(imageF2);

%imageF2 = medfilt2(imageF2); % has a default filter size or 3x3
%alternative:
%imageF2 = medfilt2(imageN, [5,5]); % this alters tne filter size


%figure, imgshow(imageF2);

