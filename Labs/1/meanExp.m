clear all, close all

img = imread('veiculoGray.jpg');

figure;
imagesc(img);
colormap gray;

%noise = round(randn(size(img))*50);
%imageN = max(min(imgg+uint8(noise),255),0);
imageN = imnoise(img,'gaussian',0,1);

figure;
imshow(imageN);


h = fspecial('average');
imageF = imfilter(imageN, h);
figure;
imshow(imageF);
