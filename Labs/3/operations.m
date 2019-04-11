clear all

I = imread('veiculoGray.jpg');


% Performing simple operations on an image:
% Rotation, flipping, etc


J1 = imrotate(I , -10, 'bilinear', 'crop');
%figure, imshow(I), figure, imshow(J1)

J2 = fliplr(I);
%figure, imshow(I), figure, imshow(J2);

J3 = flipud(I);
%figure, imshow(I), figure, imshow(J3);

J4 = permute(I, [2 1])
%figure, imshow(I), figure, imshow(J4);


% J5 below is equal to J4, but with different code:

J5 = I';

%figure, imshow(I), figure, imshow(J5);

