clear all

I = imread('veiculoGray.jpg');

JI = imrotate(I , -10, 'bilinear', 'crop');
%figure, imshow(I), figure, imshow(J1)

J2 = fliplr(I);
%figure, imshow(I), figure, imshow(J2);

J3 = flipud(I);
%figure, imshow(I), figure, imshow(J3);

J4 = permute(I, [2 1])
%figure, imshow(I), figure, imshow(J4);


% esta ultima equivalente a:

%J5 = I';

