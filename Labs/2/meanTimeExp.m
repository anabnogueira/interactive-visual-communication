clear all, close all;

imgg = imread('images/veiculoGray.jpg');

% iterations
N = 10;

% parameter for noise
div = 100;


% Unsure about the use of the following code

% Getting the size of the image?
%[L C] = size(imgg);

% New image from original image dimensions
% plus adding a new dimension
% Populating it with zeros

%MyImg = zeros(L,C,N);

% Adding noise to imgg
% salt & pepper noise is "on and off" pixels

%MyImg(1:L, 1:C, 1) = imnoise(imgg, 'salt & pepper', 0.22);


for i=1:N
    
    %   method 1
    
    %noise = round(randn(size(imgg))*div);
    %imshow(mat2gray(noise));
    %image(:,:,i) = max(min(imgg + uint8(noise), 255), 0);
    
    
    %   method 2
    
    %image(:,:,i) = imnoise(imgg , 'gaussian', 0, .12);
    
    
    %   method 3
    
    image(:,:,i) = imnoise(imgg, 'salt & pepper', 0.12);
    figure(1); imshow(image(:,:,i));
    pause(0.1)
end

%   denoising

%   method 1
denoiseImg1 = uint8(sum(double(image),3)/N);
%figure,imshow(denoiseImg1);

%   method 2
denoiseImg2 = sum(image,3)/N;
%figure, imagesc(denoiseImg2); colormap gray

%   method 3
denoiseImg3 = median(image,3);
figure, imagesc(denoiseImg3); colormap gray
