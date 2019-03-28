img = imread('rabbitBW.jpg');
%imshow(img); title('Original');
%pause
figure, hold on,
imshow(img);
%pause
se = strel('disk',3);

for k = 1: 30
    k 
    %img = imerode(img,se);
    img = imdilate(img,se);
    imshow(img); drawnow
    pause(.2)
end