close all, clear all

mlPath = pwd;
originalImg = imread('Moedas/Moedas1.jpg');

% VARIABLES
threshold = 120;
minimumArea = 6;

grayscaleRed = originalImg(:,:,1);
bw = grayscaleRed > threshold;
[lb num]=bwlabel(bw);

coinProps = regionprops(lb, 'Area', 'Perimeter');
coinProps(end) = [];

areas = sort([coinProps.Area]);
perimeters = sort([coinProps.Perimeter]);

% COIN AREAS
coin1CentA = areas(:,1);
coin2CentA = areas(:,2);
coin10CentA = areas(:,3);
coin5CentA = areas(:,4);
coin20CentA = areas(:,5);
coin1EurA = areas(:,6);
coin50CentA = areas(:,7);

% COIN PERIMETERS
coin1CentP = perimeters(:,1);
coin2CentP = perimeters(:,2);
coin10CentP = perimeters(:,3);
coin5CentP = perimeters(:,4);
coin20CentP = perimeters(:,5);
coin1EurP = perimeters(:,6);
coin50CentP = perimeters(:,7);

% EROSION OPERATION
se = strel('disk', 7);
erosionImage = imerode(bw, se);

[lbE numE]=bwlabel(erosionImage);

coinPropsEroded = regionprops(lbE, 'Area', 'Perimeter');
coinPropsEroded(end) = [];

areasE = sort([coinPropsEroded.Area]);
perimetersE = sort([coinPropsEroded.Perimeter]);

% COIN AREAS
coin1CentAE = areasE(:,1);
coin2CentAE = areasE(:,2);
coin10CentAE = areasE(:,3);
coin5CentAE = areasE(:,4);
coin20CentAE = areasE(:,5);
coin1EurAE = areasE(:,6);
coin50CentAE = areasE(:,7);

% COIN PERIMETERS
coin1CentPE = perimetersE(:,1);
coin2CentPE = perimetersE(:,2);
coin10CentPE = perimetersE(:,3);
coin5CentPE = perimetersE(:,4);
coin20CentPE = perimetersE(:,5);
coin1EurPE = perimetersE(:,6);
coin50CentPE = perimetersE(:,7);

% DELTAS
delta1CentA = coin1CentAE / coin1CentA
delta2CentA = coin2CentAE / coin2CentA
delta10CentA = coin10CentAE / coin10CentA
delta5CentA = coin5CentAE / coin5CentA
delta20CentA = coin20CentAE / coin20CentA
delta1EurA = coin1EurAE / coin1EurA
delta50CentA = coin50CentAE / coin50CentA


fprintf('\n--------------------------------------------------------------------\n')
fprintf('                              Insert Coins\n')
fprintf('--------------------------------------------------------------------\n\n')

fprintf('Choose one of the following commands to proceeed:\n\n')

fprintf('\t1 - Choose image samples from collection\n\n')
fprintf('\t2 - Choose your own image from directory\n\n')
fprintf('\t3 - Exit\n\n\n')

fprintf('Type the number of the command you wish:\n\n')
command = input('>> ');

% check the chosen command
switch command
    case 1
        fprintf('\n\n--------------------------------------------------------------------\n\n')
        
        fprintf('Choose one of the following images to proceeed:\n\n')
        fprintf('\t1 - Moedas1.jpg\n\n')
        fprintf('\t2 - Moedas2.jpg\n\n')
        fprintf('\t3 - Moedas3.jpg\n\n')
        fprintf('\t4 - Moedas4.jpg\n\n\n')
        
        fprintf('Type the number of the image you wish:\n\n')
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

    case 3
        fprintf('\nBye!\n\n')
        return
end

figure, imshow(originalImage);

% erode current image
grayscaleRedOriginal = originalImage(:,:,1);
bwOriginal = grayscaleRedOriginal > threshold;
imageEroded = imerode(bwOriginal, se);
[lbEr numEr]=bwlabel(imageEroded);

imageProps = regionprops(lbEr, 'Area', 'Perimeter');
indexes = find([imageProps.Area]>minimumArea)


while(true)
   [x, y, button] = ginput(1);
   switch button
       case 110 % Letter n - show number of objects contained in image
           fprintf('Number of Objects detected: ' + string(length(indexes)) + '\n');
       otherwise
           fprintf('nope\n');
           break;
   end
end

function n = numberOfObjects()

end
   





