close all, clear all

img = imread('cherry.bmp');

%img rgb = imread('x-ray.jpg');
%img = rgb2gray(imgrgb);

figure, imshow(img)
figure, imhist(img); hold on % compute histogram
thr = graythresh(img)*255 % automatically computes threshold

%hold on

plot(thr, 0, 'r.', 'markersize', 15) % last argument is the size of the dot
bw = img>thr;
figure, imshow(bw)

[lb num] = bwlabel(bw);
hold on
props = regionprops(lb, 'Area', 'ConvexHull', 'BoundingBox'); 
% convex hull gives the set of connected components for a given region
Acc_poligono = zeros(size(img));
aux = zeros(size(img));
figure(11)
subplot(1,2,1);
imagesc(img); colormap gray
for i = 1:num
    % roi = region of interest
    % roipoly = region of interest for the polygon
    poligono = roipoly(aux, props(i).ConvexHull(:,1),...
        props(i).ConvexHull(:,2));
    Acc_poligono = Acc_poligono + poligono; % sum the ROI to the accumulator
    figure(11)
    subplot(1,2,2);
    imagesc(Acc_poligono); axis off
    subplot(1,2,1);
    rectangle('Position', props(i).BoundingBox, 'EdgeColor', 'r', 'linewidth', 3);
    axis off
    drawnow
end
    
        