clear all, close all;

% open image
img = imread('images/veiculoGray.jpg');

% create figure/window
figure;
% imagesc - display image with scaled colours (?)
imagesc(img);
% sets the current image to gray
colormap gray;

% whatever this is?
%noise = round(randn(size(img))*50);
%imageN = max(min(imgg+uint8(noise),255),0);


% adds noise to image : imnoise(IMAGE, TYPE, ...)
% gaussian : imnoise(IMAGE, 'gaussian', MEAN, VARIANCE)
imageN = imnoise(img,'gaussian',0,1);

figure;
% show image
imshow(imageN);


% fspecial : creates predefined 2D filter (different types available)
h = fspecial('average');

% imfilter : N-D filtering of multidimensional images
% N-D filter : neutral density filter
%    a filter that reduces or modifies the intensity of all wavelengths, 
%    or colors, of light equally, giving no changes in hue of color 
%    rendition
imageF = imfilter(imageN, h);

figure;
imshow(imageF);
