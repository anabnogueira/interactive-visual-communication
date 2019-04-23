clear all,
path = 'Walking_pedestrian/'; frameIdComp = 4;

str = ['%s%.' num2str(4) 'd.%s'];
nFrame = 1233;
step = 1;



for k=1:1:nFrame/step

    str1 = sprintf(str, path, k, 'png');
    vid4D(:,:,:,k) = img; %[lines columns 3_channels_rgb nr_images] = size(vid4D)    
    
    img = imread(str1);
    imshow(img);
end


%vid4D = zeros([vid.Height vid.Width 3 nFrame/step]);
%figure,
%k = 1;

%for i=1:step:nFrame
%    i
%    img = reg(vid,i);
%    vid4D(:,:,:,k)=img;
%    imshow(img); drawnow
%    k = k+1;
%end

bkg = median(vid4D,4);
figure, imshow(uint8(bkg));

