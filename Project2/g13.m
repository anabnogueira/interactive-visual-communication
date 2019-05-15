clear all,
path = 'cvpr10_tud_stadtmitte/DaMultiview-seq'; frameIdComp = 4;

str = ['%s%.' num2str(4) 'd.%s'];
nFrame = 7022;
step = 1;

alpha = 0.25;

str1 = sprintf(str, path, nFrame, 'png');
img = imread(str1);
bkg = zeros(size(img));


for k=1:1:nFrame/step
    str1 = sprintf(str, path, nFrame, 'png');
    img = imread(str1);
    
    vid4D(:,:,:,k) = img; %[lines columns 3_channels_rgb nr_images] = size(vid4D)    
    Y = img;
    
    bkg = alpha * double(Y) + (1 - alpha) * double(bkg);
    imshow(img);
    %imshow(uint8(bkg)); drawnow
    %pause(.2)
    nFrame = nFrame + step;
end

