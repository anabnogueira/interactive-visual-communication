clear all;

threshold = 30;
minimumArea = 60;
maximumArea = 7000;

% erosion + dilation
seErosion = strel('disk', 3);
seErosion2 = strel('disk', 4);
seDilation = strel('disk', 7);

seqLength = 795;
startNum = 000000;

% Read annotations and compute background
text = readFile();

%backgroundStruct = load('backgroundImg.mat');
%imgbk = backgroundStruct.imgbk;
%map1 = [];
[imgbk, map1] = computeBackground(seqLength, startNum);

[startF, endF] = selectVideoSection();

figure('Name','Tracking of Pedestrians', 'Position', [10 10 1200 700]);
[w, h, m] = size(imgbk);

points = []; % saves points of current frame
allPoints = []; % saves all points in matrix

axBG = subplot(1,2,2), imshow(imgbk,map1);
title('Trajectories performed');
xlabel('Paths detected by the algorithm');

axFrame = subplot(1,2,1), imshow(imgbk,map1);
title('Video and detections');
xlabel('Red - ground truth    Blue - algorithm detections    Green - true positives');


heatMatrix = zeros(w+2,h+2);
matrixPR = [];
intersections = [];

for frame=startF:endF
    [currentImg,map2] = imread(sprintf('PETS09-S2L2/img1/%.6d.jpg', startNum + frame));
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
    [points, heatMatrix, allPoints] = computePoints(regionProps, inds, heatMatrix, allPoints);
    
    
    % label GT
    GTbinary = zeros(w,h);
    GTbinary = drawBBs(text, frame, GTbinary);
    
    [lbGT numGT] = bwlabel(GTbinary);
    regionPropsGT = regionprops(lbGT, 'area', 'FilledImage', 'Centroid', 'BoundingBox');
    
    % plot bounding box
    for l=1:length(regionPropsGT)
        currBB = regionPropsGT(l).BoundingBox;
        rectangle('Position',[currBB(1),currBB(2),currBB(3),currBB(4)],'EdgeColor','r','LineWidth',1 );
    end
    
    intersectionOverUnion = findIntersectionsFromBinary(regionPropsGT, regionProps, w, h, inds, GTbinary);
    frameIntersection = [frame-1 intersectionOverUnion];
    intersections = [intersections ; frameIntersection ];
    
    % Evaluation
    overlaps = computeOverlapRatio(regionPropsGT, regionProps);
    
    overlapsTP = getOverlaps(overlaps);
    
    plotTruePositives(regionPropsGT, overlapsTP);
    
    fp = countFalsePositives(overlapsTP);
    fn = countFalseNegatives(overlapsTP);
    
    matrixPR = computePrecisionRecall(matrixPR, overlapsTP, fp, fn);    
    
    axes(axBG);
    hold on;
    plotPoints(points);
    
    points = [];
    drawnow;
    
    previousFrameProps = regionProps;
    hold off;
    
    if (frame ~= endF)
        cla(axFrame);
    end
end

while (true)
    [x, y, button] = ginput(1);
    
    switch(button)
        case 113 % q - quit
            close all;
            break;
            
        case 109 % m - plot evaluation metrics
            figure;
            
            set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

            plotPrecision(matrixPR(:,1), startF, endF);
            plotRecall(matrixPR(:,2), startF, endF);
            plotPrecisionRecall(matrixPR(:,1), matrixPR(:,2));
            plotIoU(intersections);
            [x, y, buttong] = ginput(1);
            if buttong
                close;
            end
            
        case 104 % h - heat map
            st = offsetstrel('ball', 20, 30);
            heatMatrix = imdilate(heatMatrix, st);
            hm = HeatMap(flipud(heatMatrix), 'Symmetric', 'false');
            hm.Colormap = 'jet';

        case 103 % g - graphs
            plotGraph(allPoints, w, h);
            [x, y, buttong] = ginput(1);
            if buttong
                close;
            end
            
        otherwise
            continue;
    end
end

function [startFrame, endFrame] = selectVideoSection()
fprintf('Range of frames (0-795):\n\n')
fprintf('Select start frame\n\n')
startFrame = input('>> ');
fprintf('Select end frame\n\n')
endFrame = input('>> ');
end

function [bg, map] = computeBackground(length, startNum)
alpha = 0.0012;

for z=1:length
    [currImg, map] = imread(sprintf('img1/%.6d.jpg', startNum + z));
    bkg = zeros(size(currImg));
    
    videoData(:,:,:,z) = currImg;
    Y = currImg;
    
    bkg = alpha * double(Y) + (1 - alpha) * double(bkg);
end
bkg = median(videoData,4);
bg = uint8(bkg);
end

function [pointsret, matrixret, totalPoints] = computePoints(props, indexes, matrix, totalPoints)
pointsret = [];
for l=1:length(indexes)
    currBB = props(indexes(l)).BoundingBox;
    currCentroid = props(indexes(l)).Centroid;
    point(1) = currCentroid(1);
    point(2) = currBB(2) + currBB(4);
    pointsret = [pointsret; point];
    totalPoints = [totalPoints ; point];
    
    matrix(ceil(point(2)), ceil(point(1))) = matrix(ceil(point(2)), ceil(point(1))) + 4;
end
matrixret = matrix;
end

function plotPoints(pointsVector)
for m=1:length(pointsVector)
    plot(pointsVector(m,1), pointsVector(m,2),'.b', 'LineWidth', 2);
end
end

% plot scatterplot
function plotGraph(points, w, h)
figure;
y = h - points(:,2);
cmap = jet(length(points(:,1)));
sc = scatter(points(:,1), y, 160, cmap, 'filled');
colormap jet;
colorbar('Ticks',[0,1], 'TickLabels',{'Least Recent','Most Recent'}, 'FontSize', 12);
title('Map of trajectories', 'FontSize', 25);
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
end

% read annotations from file
function text = readFile()
fid = fopen('gt.txt');
fileSize = [10 Inf];
text = fscanf(fid, '%d, %d, %d, %d, %f, %f, %f, %f, %f, %d\n', fileSize);
text = text';
end

% draw bounding boxes
function matrix = drawBBs(text, frameN, matrixRegions)
[m n] = size(text);
for i=1:m
    if text(i,1) == frameN
        pointx = text(i,3);
        pointy = text(i,4);
        width = text(i,5);
        height = text(i,6);
        
        for a=pointx : (pointx + width)
            for b=pointy : (pointy + height)
                matrixRegions(b,a) = 1;
            end
        end
    end
    matrix = matrixRegions;
end
end

% returns matrix with overlap ratios between bounding boxes
function matrix = computeOverlapRatio(gt, det)
matrix = zeros(length(gt),length(det));

for a=1:length(gt)
    for b=1:length(det)
        matrix(a, b) = bboxOverlapRatio(gt(a).BoundingBox, det(b).BoundingBox);
    end
end
end

% computes overlaps between ground truth and detections (returns true positives)
function overlapsTP = getOverlaps(overlaps)
overlapsTP = overlaps > 0.25;
end

% generates green bounding box around true positives
function plotTruePositives(gt, overlapsTP)
[m n] = size(overlapsTP);
for i=1:m
    for j=1:n
        if overlapsTP(i,j) == 1
            currBB = gt(i).BoundingBox;
            rectangle('Position',[currBB(1),currBB(2),currBB(3),currBB(4)],'EdgeColor','g','LineWidth', 2);
        end
    end
end
end

% count false positives in current frame
function FP = countFalsePositives(overlapsTP)
[m n] = size(overlapsTP);
FP = 0;
for i=1:n
    if sum(overlapsTP(:,i)) == 0
        FP = FP + 1;
    end
end
end

% count false negatives in current frame
function FN = countFalseNegatives(overlapsTP)
[m n] = size(overlapsTP);
FN = 0;
for i=1:m
    if sum(overlapsTP(i,:)) == 0
        FN = FN + 1;
    end
end
end

% get IoU values larger than 0
function intersections = findIntersections(intersections, overlaps, frame)

indexes = find(overlaps > 0);
for k=1:length(indexes)
    is = [frame overlaps(indexes(k))];
    intersections = [intersections ; is];
end
end

% creates binary masks from bounding box coordinates
function img = createMask(props, l, c, inds, gtbinary)
img = zeros(l,c);
if isempty(inds)
    img = gtbinary;
else
    for a=1:length(inds)
        tlX = round(props(inds(a)).BoundingBox(1));
        tlY = round(props(inds(a)).BoundingBox(2));
        trX = tlX + props(inds(a)).BoundingBox(3);
        trY = tlY;
        brX = trX;
        brY = trY + props(inds(a)).BoundingBox(4);
        blX = tlX;
        blY = brY;
        x = [tlX trX brX blX];
        y = [tlY trY brY blY];
        imgtemp = roipoly(img, x, y);
        img = img + imgtemp;
    end
end
end

% finds intersections through masks
function iou = findIntersectionsFromBinary(gtprops, imgprops, l, c, inds, gtbinary)
gtMask = createMask(gtprops, l, c, [], gtbinary);
imgMask = createMask(imgprops, l, c, inds, gtbinary);
intersectRegions = gtMask.*imgMask;
unionRegions = logical(gtMask + imgMask);
iou = sum(intersectRegions) / sum(unionRegions);

end

% compute precision and recall values for current frame
function matrixPR = computePrecisionRecall(matrixPR, overlapsTP, fp, fn)
tp = sum(overlapsTP);

precision = tp / (tp + fp);
recall = tp / (tp + fn);

pr = [precision recall];
matrixPR = [matrixPR ; pr];
end

% plot precision graph
function plotPrecision(precision, startF, endF)
x = [startF-1 : 1 : endF-1];
gr1 = subplot(2,2,1);
plot(x, precision, 'r-', 'LineWidth', 2);
title('Precision/frame');
xlabel('# Frame');
ylabel('Precision');
end

% plot recall graph
function plotRecall(recall, startF, endF)
x = [startF-1 : 1 : endF-1];
gr3 = subplot(2,2,3);
plot(x, recall, 'm-', 'LineWidth', 2);
title('Recall/frame');
xlabel('# Frame');
ylabel('Recall');
end

% plot precision recall
function plotPrecisionRecall(precision, recall)
gr2 = subplot(2,2,2);
scatter(recall, precision, 60, 'filled');
axis([0 1 0 1]);
title('Precision-Recall');
xlabel('Recall');
ylabel('Precision');
end

% plot intersection over union
function plotIoU(intersections)
gr4 = subplot(2,2,4);
plot(intersections(:,1).', intersections(:,2), 'LineWidth', 2);
title('Intersection Over Union');
xlabel('# Frames');
ylabel('IoU');
end
