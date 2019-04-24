% - - - - - - - - - - - - - - - - - - - - - - - - - -
%                   First Lab Work                  |
% - - - - - - - - - - - - - - - - - - - - - - - - - -
%                       Group 13                    |
% - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - -
%               82433   Ana Nogueira                |
%               83553   Pilar Pereira               |
%               83563   Sara Franco                 |
% - - - - - - - - - - - - - - - - - - - - - - - - - -
% - - - - - - - - - - - - - - - - - - - - - - - - - -

close all, clear all

% gets current matlab path
mlPath = pwd;

% - - - - - - - - - - - - - - - - - - - - - - - - - -
%                       Menu                        |
% - - - - - - - - - - - - - - - - - - - - - - - - - -

fprintf('\n--------------------------------------------------------------------\n')
fprintf('                              Insert Coins\n')
fprintf('--------------------------------------------------------------------\n\n')

fprintf('Choose one of the following commands to proceeed:\n\n')

fprintf('\t0 - Choose your own image from directory\n\n')
fprintf('\t1 - Choose image samples from collection\n\n')
fprintf('\t2 - Exit\n\n\n')

fprintf('Type the number of the command you wish:\n\n')
command = input('>> ');

% check the chosen command
switch command
    case 0
        fprintf('\n\n--------------------------------------------------------------------\n\n')
        
        fprintf('Choose your own image and place it in the current matlab path\n\n')
        fprintf('Current MATLAB path is\n\t>> ')
        fprintf(mlPath)
        
        fprintf('\n\nListing directory contents:\n\n')
        fprintf('\t')
        dir
        fprintf('\n\n--------------------------------------------------------------------\n\n')
        
        fprintf('Insert filename of image\n')
        fprintf('OR\n')
        fprintf('type "refresh" to update directory listing\n\n')
        filename = input('>> ', 's');
        
        while strcmp(filename, 'refresh')
            fprintf('\n\nListing directory contents:\n\n')
            fprintf('\t')
            dir
            fprintf('\n\n--------------------------------------------------------------------\n\n')
            fprintf('Insert filename of image\n')
            fprintf('OR\n')
            fprintf('type "refresh" to update directory listing\n\n')
            filename = input('>> ', 's');
        end
        
        % try to open file specified
        try
            imshow(filename)
        catch
            fprintf('\nERROR: File not found in directory!\n\n')
            
        end

        
    case 1
        fprintf('\n\n--------------------------------------------------------------------\n\n')
        
        fprintf('Choose one of the following images to proceeed:\n\n')
        fprintf('\t1 - Moedas1.jpg\n\n')
        fprintf('\t2 - Moedas2.jpg\n\n')
        fprintf('\t3 - Moedas3.jpg\n\n')
        fprintf('\t4 - Moedas4.jpg\n\n\n')
        
        fprintf('Type the number of the images you wish:\n\n')
        imgNr = input('>> ');
        
        switch imgNr
            case 1
                imgPath = 'Moedas/Moedas1.jpg';
                originalImage = imread(imgPath);
            case 2
                imgPath = 'Moedas/Moedas2.jpg';
                originalImage = imread(imgPath);
            case 3
                imgPath = 'Moedas/Moedas3.jpg';
                originalImage = imread(imgPath);
            case 4
                imgPath = 'Moedas/Moedas4.jpg';
                originalImage = imread(imgPath);
            otherwise
                fprintf('\nERROR: Invalid image number!\n')
        end
        
    case 2
        fprintf('\nBye!\n\n')
        return
end

threshold = 115;
minArea = 15;

se = strel('disk', 9);
se2 = strel('disk', 9);

grayscaleRed = originalImage(:,:,1);
bw = grayscaleRed > threshold;
figure, imshow(bw)
bw1 = imerode(bw, se);
figure, imshow(bw1);
bw2 = imdilate(bw1, se);
figure, imshow(bw2);
keyboard
[lb num]=bwlabel(bw1);
regionProps = regionprops(lb,'Area','FilledImage','Centroid', 'Perimeter');
inds = find([regionProps.Area]>minArea) % regions 

[lb num]=bwlabel(bw2);
regionProps2 = regionprops(lb,'Area','FilledImage','Centroid', 'Perimeter');
inds2 = find([regionProps.Area]>minArea) % regions 

%BW2 = bwperim(bw2,8);
%imshow(BW2);




hold on
for i=1:length(inds)
    %figure,imshow(regionProps(inds(i)).FilledImage);
    props = regionprops(double(regionProps(inds(i)).FilledImage),...
        'Orientation','MajorAxisLength','MinorAxisLength');
    ellipse(props.MajorAxisLength/2,props.MinorAxisLength/2,-props.Orientation*pi/180,...
      regionProps(inds(i)).Centroid(1),regionProps(inds(i)).Centroid(2),'r');
    
    plot(regionProps(inds(i)).Centroid(1),regionProps(inds(i)).Centroid(2),'g*')
    
    

    fprintf('Object #' + string(i) + '\n');
    fprintf('Centroid X: '+string(regionProps(inds(i)).Centroid(1))+'\n');
    fprintf('Centroid Y: '+string(regionProps(inds(i)).Centroid(2))+'\n');
    fprintf('Perimeter: '+string(regionProps(inds(i)).Perimeter)+'\n');
    fprintf('Area: '+string(regionProps(inds(i)).Area)+'\n\n');

end




