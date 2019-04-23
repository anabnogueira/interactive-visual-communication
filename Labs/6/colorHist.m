clear all,
N = 100; % histograma

img1 = imread('ped7c1352.tif');
figure, imshow(img1);
[nlin ncol dummy] = size(img1);
npixels = nlin*ncol;
hr = imhist(img1(:,:,1), N) / npixels;
hg = imhist(img1(:,:,2), N) / npixels;
hb = imhist(img1(:,:,3), N) / npixels;
H1 = [hr' hg' hb'];
figure, bar(H1);

img2 = imread('ped7c1350.tif');
figure, imshow(img2);
[nlin ncol dummy] = size(img2);
npixels = nlin*ncol;
hr = imhist(img1(:,:,1), N) / npixels;
hg = imhist(img1(:,:,2), N) / npixels;
hb = imhist(img1(:,:,3), N) / npixels;
H2 = [hr' hg' hb'];
figure, bar(H2);

img3 = imread('Tiger2.jpg');
figure, imshow(img2);
[nlin ncol dummy] = size(img3);
npixels = nlin*ncol;
hr = imhist(img1(:,:,1), N) / npixels;
hg = imhist(img1(:,:,2), N) / npixels;
hb = imhist(img1(:,:,3), N) / npixels;
H3 = [hr' hg' hb'];
figure, bar(H3);

d12 = sum(abs(H1-H2))/length(H1)
d13 = sum(abs(H1-H3))/length(H1)


