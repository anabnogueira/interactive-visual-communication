clear all,
path = 'Walking_pedestrian/'; frameIdComp = 4;

str = ['%s%.' num2str(4) 'd.%s'];
%nFrame = 1233;
%step = 1;
nFrame = 1230;
step = 10;


for k=1:1:nFrame/step
    str1 = sprintf(str, path, k, 'png');
    img = imread(str1);
    vid4D(:,:,:,k) = img; %[lines columns 3_channels_rgb nr_images] = size(vid4D)    
    imshow(img);
end

bkg = median(vid4D,4);
figure, imshow(uint8(bkg));

alpha = 0.25
bkg(zeros(img));

