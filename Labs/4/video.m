clear all
imgbk = imread('database_PED/ped7c0000.tif');

thr = 40;
minArea = 200;

baseNum = 1350;
seqLength = 99;

% baseNum = 1374;
% seqLength = 0;
% imshow(imgdif)
se = strel('disk', 3);

figure;
%pause

for i=0:seqLength
    imgfr = imread(sprintf('database_PED/ped7c%.4d.tif',baseNum+1));
    baseNum = baseNum+1;
    hold off
    imshow(imgfr); 
end