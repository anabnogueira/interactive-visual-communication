clear all;

threshold = 30;
minimumArea = 20;
maximumArea = 6000;

% erosion + dilation
seErosion = strel('disk', 3);
seErosion2 = strel('disk', 4);
seDilation = strel('disk', 7);


seqLength = 795;
startNum = 000000;

%imgbk = computeBackground(seqLength, startNum);
[imgbk,map1] = imread('img1/BACKGROUND4.jpg');
figure('Name','Image', 'Position', [10 10 1200 800]);
[w, h] = size(imgbk);

points = [];

axBG = subplot(1,2,2), imshow(imgbk,map1);
axFrame = subplot(1,2,1), imshow(imgbk,map1);

heatMatrix = zeros(w+1,h+1);

for a=1:200
    [currentImg,map2] = imread(sprintf('img1/%.6d.jpg', startNum + a));
    %imshow(currentImg), hold on;
    axes(axFrame);
    hold on;
    imshow(currentImg,map2);
    
    hold on;
    
    imgdif = ...
        (abs(double(imgbk(:,:,1))-double(currentImg(:,:,1)))>threshold) | ...
        (abs(double(imgbk(:,:,2))-double(currentImg(:,:,2)))>threshold) | ...
        (abs(double(imgbk(:,:,3))-double(currentImg(:,:,3)))>threshold);
    imgdif = imerode(imgdif, seErosion);
    imgdif = imdilate(imgdif, seDilation);
    imgdif = imerode(imgdif, seErosion2);
    
    [lb num] = bwlabel(imgdif);
    regionProps = regionprops(imgdif, 'area', 'FilledImage', 'Centroid', 'BoundingBox');
    inds1 = find([regionProps.Area] > minimumArea);
    inds2 = find([regionProps.Area] < maximumArea);
    inds = intersect(inds1, inds2);
    
    % plot bounding box
    for k=1:length(inds)
        currBB = regionProps(inds(k)).BoundingBox;
        rectangle('Position',[currBB(1),currBB(2),currBB(3),currBB(4)],'EdgeColor','b','LineWidth',1 );
    end
    [points, heatMatrix] = computePoints(regionProps, inds, heatMatrix);

    
    axes(axBG);
    hold on;
    plotPoints(points);
    
    points = [];
    drawnow;
    
    previousFrameProps = regionProps;
    hold off;
    
    cla(axFrame);
    
end

hm = HeatMap(heatMatrix.', 'Symmetric', 'false');
hm.Colormap = 'parula';

function bg = computeBackground(length, startNum)
alpha = 0.0012;

for z=1:length
    currImg = imread(sprintf('img1/%.6d.jpg', startNum + z));
    bkg = zeros(size(currImg));
    
    videoData(:,:,:,z) = currImg;
    Y = currImg;
    
    bkg = alpha * double(Y) + (1 - alpha) * double(bkg);
    %imshow(img);
end
bkg = median(videoData,4);
bg = uint8(bkg);
end

function [pointsret, matrixret] = computePoints(props, indexes, matrix)
pointsret = [];
for l=1:length(indexes)
    currBB = props(indexes(l)).BoundingBox;
    currCentroid = props(indexes(l)).Centroid;
    point(1) = currCentroid(1);
    point(2) = currBB(2) + currBB(4);
    pointsret = [pointsret; point];
    ceil(point(2))
    ceil(point(1))
    matrix(ceil(point(2)), ceil(point(1))) = matrix(ceil(point(2)), ceil(point(1))) + 1;
    matrixret = matrix;
    
    
end
end

function plotPoints(pointsVector)
for m=1:length(pointsVector)
    plot(pointsVector(m,1), pointsVector(m,2),'.b', 'LineWidth', 2);
end
end