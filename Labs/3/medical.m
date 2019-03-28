clear all, close all

img = imread('BrainMRI_Axial.jpg');
imshow(img); title('Original');
imgg = rgb2gray(img);
%figure,imhist(imgg);

BW = imgg > 60;
figure,
subplot(2,3,1);
imshow(BW);title('Original BW');
se = strel('disk',3);
% se = strel('line',3,45);
% se = strel('square',3);
% se = strel('ball',3);

BW1 = imerode(BW,se);
subplot(2,3,2);imshow(BW1);title('Erosao');

BW2 = imdilate(BW,se);
subplot(2,3,3);imshow(BW2);title('Dilatacao');

BW3 = imopen(BW,se);
subplot(2,3,4);imshow(BW3);title('Abertura');

BW4 = imclose(BW,se);
subplot(2,3,5);imshow(BW4);title('Fecho');

[lb num] = bwlabel(BW3);
figure,
subplot(1,3,1);imshow(mat2gray(lb));title('Labels');
%subplot(1,3,1);imshow(label2rgb(lb));title('Labels');
stats = regionprops(lb);
areas = [stats.Area];
[dummy indM] = max(areas);
imgBr = (lb == indM);
subplot(1,3,2); imshow(imgBr);title('Maior area');
subplot(1,3,3); imshow(imgg.*uint8(imgBr));title('Cerebro');
%alternativa
subplot(1,3,3);imshow(double(imgg).*(imgBr)); title('Cerebro');

areas = [];
for k=1 : num
    areas = [areas length(find(lb==k))]
end

[val ind] = max(areas)
