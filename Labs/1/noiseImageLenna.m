clear all, close all

imgg = imread('images/lena512.bmp');

%figure, imshow(imgg)
image = imnoise(imgg, 'salt & pepper', 0.05);
%figure, imshow(image);

% BELOW:
% imfilter - applies neutral density filter over image
%   fspecial - creates filter of type with specific parameters

% -- method 1 --
%       ('gaussian', HSIZE, SIGMA)
%           HSIZE - filter size, either AxB matrix or scalar (default 3x3)
%           SIGMA - positive deviation (default 0.5)

K1 = imfilter(image, fspecial('gaussian', 11, 1));
figure, imshow(K1)


% -- method 2 --
%       ('average', HSIZE)
%           HSIZE - filter size, either AxB matrix or scalar (default 3x3)

K2 = imfilter(image, fspecial('average', 3));
figure, imshow(K2)


% -- method 3 --
% medfilt2(A, [M N])
% medfilt2 - performs median filtering of the matrix A in two dimensions
% Each output pixel contains the median value in the M-by-N neighbourhood

K3 = medfilt2(image, [3,3]);
figure, imshow(K3)

