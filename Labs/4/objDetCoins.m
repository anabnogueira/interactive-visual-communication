clear all, close all;

%thr = 200;

minArea = 20;

imgg = imread('eight.tif');
figure,imshow(imgg);


thr = floor(graythresh(imgg)*256); % or use hard coded like in line 3


se = strel('disk',3);
bw1 = imgg < thr;
imshow(bw1);
%cleaning operations
bw2 = imclose(bw1,se);
imshow(bw2);

%region detection operation
[lb num]=bwlabel(bw2);
regionProps = regionprops(lb,'area','FilledImage','Centroid');
inds = find([regionProps.Area]>minArea); % regions 

hold on
for i=1:length(inds)
    %figure,imshow(regionProps(inds(i)).FilledImage);
    props = regionprops(double(regionProps(inds(i)).FilledImage),...
        'Orientation','MajorAxisLength','MinorAxisLength');
    ellipse(props.MajorAxisLength/2,props.MinorAxisLength/2,-props.Orientation*pi/180,...
      regionProps(inds(i)).Centroid(1),regionProps(inds(i)).Centroid(2),'r');
    
    plot(regionProps(inds(i)).Centroid(1),regionProps(inds(i)).Centroid(2),'g*')
    if exist('propsT')
        propsT = [propsT props];
    else
        propsT = props;
    end
end
N = length(inds)
str1  = sprintf('%s%d','O n? de objectos ? ',N)