clear all, close all

img = imread('images/veiculoGray.jpg');

imageN = imnoise(img, 'salt & pepper', 0.42);
figure, imshow(imageN);

% medfilt2 : 2-D median filtering
%   medfilt2(IMG) performs median filterning of the matrix A using
%   the default 3x3 neighbourhood

imageF2 = medfilt2(imageN);
figure, imshow(imageF2);

% alternative:
% this alters the filter size to 5x5 :

imageF2 = medfilt2(imageN, [5 5]); 
figure, imshow(imageF2);

