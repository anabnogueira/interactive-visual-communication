clear all, close all

imgg = imgread('lena512.bmp');

figure, imgshow(imgg)
image = imnoise(imgg, 'salt & pepper', 0, 0.05);
figure, imshow(image);

% method 1
% K = imfilter(image, fspecial('gaussian', 11, 1));
K1 = imfilter(image, fspecial('average', 3));

% method 2
K2 = medfilt2(image, [3,3]);
figure, imshow(K1)
figure, imshow(K2)
