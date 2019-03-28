clear all,

myPath = 'database_PED/';

N = 100;

img1 = imread(strcat(myPath, 'ped7c1352.tif'));
figure,imshow(img1);
[nlin ncol dummy] = size(img1);
npixels = nlin * ncol;
hr = imhist(img1(:,:,1),N)/npixels;
hg = imhist(img1(:,:,2),N)/npixels;
hb = imhist(img1(:,:,3),N)/npixels;
H1 = [hr' hg' hb'];
figure, bar(H1);


