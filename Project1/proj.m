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

grayscaleRed = originalImage(:,:,1);
bw = grayscaleRed > threshold;
imshow(bw);

[lb num]=bwlabel(bw);
regionProps = regionprops(lb,'area','FilledImage','Centroid');
inds = find([regionProps.Area]>minArea) % regions 

nrObjects = length(inds)



