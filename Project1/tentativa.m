close all, clear all

mlPath = pwd;
originalImg = imread('Moedas/Moedas1.jpg');

% VARIABLES
threshold = 120;
minimumArea = 6;

grayscaleRed = originalImg(:,:,1);
bw = grayscaleRed > threshold;
[lb num] = bwlabel(bw);

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
seEr = strel('disk', 7);
seOp = strel('disk', 3);
erosionImage = imerode(bw, seEr);
openImage = imdilate(erosionImage, seOp);

[lbO numO]=bwlabel(openImage);

coinPropsOpened = regionprops(lbO, 'Area', 'Perimeter');
coinPropsOpened(end) = [];

areasO = sort([coinPropsOpened.Area]);
perimetersO = sort([coinPropsOpened.Perimeter]);

% COIN AREAS
coin1CentAO = areasO(:,1);
coin2CentAO = areasO(:,2);
coin10CentAO = areasO(:,3);
coin5CentAO = areasO(:,4);
coin20CentAO = areasO(:,5);
coin1EurAO = areasO(:,6);
coin50CentAO = areasO(:,7);

% COIN PERIMETERS
coin1CentPE = perimetersO(:,1);
coin2CentPE = perimetersO(:,2);
coin10CentPE = perimetersO(:,3);
coin5CentPE = perimetersO(:,4);
coin20CentPE = perimetersO(:,5);
coin1EurPE = perimetersO(:,6);
coin50CentPE = perimetersO(:,7);

% DELTAS
%delta1CentA = coin1CentAE / coin1CentA;
%delta2CentA = coin2CentAE / coin2CentA;
%delta10CentA = coin10CentAE / coin10CentA;
%delta5CentA = coin5CentAE / coin5CentA;
%delta20CentA = coin20CentAE / coin20CentA;
%delta1EurA = coin1EurAE / coin1EurA;
%delta50CentA = coin50CentAE / coin50CentA;

delta1CentA = (coin1CentA - coin1CentAO) * 3/7;
delta2CentA = (coin2CentA - coin2CentAO) * 3/7;
delta10CentA = (coin10CentA - coin10CentAO) * 3/7;
delta5CentA = (coin5CentA - coin5CentAO) * 3/7;
delta20CentA = (coin20CentA - coin20CentAO) * 3/7;
delta1EurA = (coin1EurA - coin1EurAO) * 3/7;
delta50CentA = (coin50CentA - coin50CentAO) * 3/7;


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

figure, hold on, imshow(originalImage);

% erode current image
grayscaleRedOriginal = originalImage(:,:,1);
bwOriginal = grayscaleRedOriginal > threshold;
imageEroded = imerode(bwOriginal, seEr);
imageOpened = imdilate(imageEroded, seOp);

[labelsOpened numOp]=bwlabel(imageOpened);
imageProps = regionprops(labelsOpened, 'Area', 'Perimeter', 'Centroid', 'FilledImage', 'BoundingBox');
indexes = find([imageProps.Area]>minimumArea);

newField = 'Circularity';
for p=1:length(indexes)
   imageProps(p).(newField) = (imageProps(p).Perimeter).^2 / imageProps(p).Area;
end

newField = 'Sharpness';                   
for p=1:length(indexes)
   [Gx, Gy] = gradient(imageProps(p).FilledImage);
   S = sqrt(Gx.*Gx+Gy.*Gy);
   sharpness = sum(sum(S))./(numel(Gx));
   imageProps(p).(newField) = sharpness;
end


while(true)
   [x, y, button] = ginput(1);
   switch button
       case 110 % Letter n - show number of objects contained in image
           fprintf('Number of Objects detected: ' + string(length(indexes)) + '\n');
       case 109 % Letter m - show coin/object measurements
           hold on
           for i=1:length(indexes)
               [B,L,N] = bwboundaries(imageOpened);

               % Plot object boundaries          
               for k=1:length(B)
                   boundary = B{k};
                   if(k > N)
                       plot(boundary(:,2), boundary(:,1), 'w--', 'LineWidth', 3);
                   else
                       plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth',4);
                   end
               end
               % plot centroids
               plot(imageProps(indexes(i)).Centroid(1),imageProps(indexes(i)).Centroid(2),'rx', 'LineWidth', 21)
           end
           
           while(true)
               % select region
               [xm, ym, buttonm] = ginput(1);
               
               if (buttonm == 113) % Press q to quit
                       imshow(originalImage);
                       break;
               end
               
               if (buttonm == 1)
                   ret = labelsOpened(round(ym),round(xm));
                   if (ret ~= 0)
                       xr = imageProps(ret).Centroid(1);
                       yr = imageProps(ret).Centroid(2);

                       % region information
                       regionText = strcat('Region #', num2str(ret));
                       areaText = {'Area:', num2str(imageProps(ret).Area)};
                       areaTextCat = strjoin(areaText, ' '); 
                       perimeterText = {'Perimeter:', num2str(imageProps(ret).Perimeter)};
                       perimeterTextCat = strjoin(perimeterText, ' ');
                       legendText = {regionText, areaTextCat, perimeterTextCat}; 
                       legendTextCat = strjoin(legendText, '\n');

                       % position textbox
                       t = text(xr-200-imageProps(ret).Perimeter/(2*pi), yr-imageProps(ret).Perimeter/(2*pi), legendTextCat, 'FontSize', 12,'FontWeight', 'bold');

                       % textbox formatting
                       t.BackgroundColor = 'w';
                       t.Color = 'k';
                       t.FontSmoothing = 'on';
                       t.FontSize = 10;
                       t.Margin = 5;
                   end
               end
           end
           
           
       case 100 % Letter d - compute distances
           while(true)
               [xm, ym, buttond] = ginput(1);
               ret = labelsOpened(round(ym),round(xm));
               
               if (buttond == 113) % Press q to quit
                       imshow(originalImage);
                       break;
               end
               
               if (buttond == 114) % Press r to reset
                       imshow(originalImage);
               end
               
               if (buttond == 1)
                   hold on
                   for j=1:length(indexes)
                       if (j ~= ret)
                           x1 = imageProps(ret).Centroid(1);
                           y1 = imageProps(ret).Centroid(2);
                           x2 = imageProps(indexes(j)).Centroid(1);
                           y2 = imageProps(indexes(j)).Centroid(2);
                           distance = sqrt((x1-x2).^2 + (y1-y2).^2);
                           plot(imageProps(ret).Centroid(1),imageProps(ret).Centroid(2),'rx', 'LineWidth', 3);
                           plot(imageProps(indexes(j)).Centroid(1),imageProps(indexes(j)).Centroid(2),'rx', 'LineWidth', 3);
                           plot([round(x1) round(x2)], [round(y1) round(y2)], 'k:', 'LineWidth', 2);

                           % Plot Distance Information
                           xnew = x1 - (x1-x2)/2;
                           ynew = y1 - (y1-y2)/2;

                           t = text(round(xnew), round(ynew), num2str(distance), 'FontSize', 9,'FontWeight','bold');

                           % textbox formatting
                           t.BackgroundColor = 'w';
                           t.Color = 'k';
                           t.FontSmoothing = 'on';
                           t.FontSize = 10;
                           t.Margin = 5;
                       end
                   end
               end             
           end
           
           
       case 103 % Letter g - show boundary derivative graph
           while(true)
               % select region
               [xb, yb, buttonBound] = ginput(1);
               ret = labelsOpened(round(yb),round(xb));
               
               if (ret ~= 0)
                   hold on
                   [B,L,N] = bwboundaries(imageOpened);
                   boundary = B{ret};
                   
                   plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth', 4);

                   % get number of points to show in boundary from console
                   fprintf('\nChoose number of points:\n');
                   nrPoints = input('>> ');             
               
                   % step to traverse matrix
                   step = round(length(B{ret})/nrPoints);
                   index = 1;
                   a = [];
                   b = [];
                   % plot points over boundary
                   for l=1:nrPoints
                       plot(B{ret}(index,2), B{ret}(index,1),'ro', 'LineWidth', 3);
                       a = [a ; B{ret}(index,2), B{ret}(index,1)];
                       index = index + step;
                   end
                   % determine derivative between chosen points
                   for m=1:length(a)
                       % check if it is the last el
                       % determine derivative between last and first el
                       if(a(end,:) == a(m,:))
                          slope = (a(1,2) - a(m,2))/(a(1,1) - a(m,1));
                          b = [b ; slope]; 
                          break;
                       end
                       slope = (a(m+1,2) - a(m,2))/(a(m+1,1) - a(m,1));
                       b = [b ; slope];
                   end
                   
                   % create graph
                   graphFigure = figure;
                   a(end,:) = [];
                   x = [1:1:length(b)];
                   x = x.';
                   y = b;
                   graph = plot(x,y);
                   % format graph
                   graph.LineWidth = 2;
                   graph.Color = 'r';
                   ax = gca;
                   ax.XAxisLocation = 'origin';
                   
                   % wait for input on graph window
                   [xg, yg, buttonGraph] = ginput(1);
                   if (buttonGraph == 113)
                       close(graphFigure);
                   end
                   
                   % wait for input on image window
                   [xm, ym, buttonAfter] = ginput(1);
                   if (buttonAfter == 113) % Press q to quit
                           imshow(originalImage);
                           break;
                   end
                   if (buttonAfter == 114) % Press r to reset
                           imshow(originalImage);
                   end
               end               
           end
           
       case 111 % Letter o - order by different parameters
           fprintf('Select parameter to order by:\n');
           fprintf('1 - Area\n');
           fprintf('2 - Perimeter\n');
           fprintf('3 - Circularity\n');
           fprintf('4 - Sharpness\n');
           while(true)
               [xo, yo, buttonOrder] = ginput(1);
               
               if (buttonOrder == 113) % Press q to quit
                   close(orderedFigure);
                   imshow(originalImage);
                   break;
               end
               
               if (buttonOrder == 114) % Press r to reset
                   close(orderedFigure);
                   imshow(originalImage);
               end
               
               if(buttonOrder == 49) % press 1 - order by area
                   regionAreas = [imageProps.Area];
                   [sorted, ind] = sort(regionAreas);
                   orderedFigure = figure;
                   hold on;
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       subplot(1, length(ind), o), imshow(cropped);
                   end
               end
               
               if(buttonOrder == 50) % press 2 -order by perimeter
                   regionPerimeters = [imageProps.Perimeter];
                   [sorted, ind] = sort(regionPerimeters);
                   orderedFigure = figure;
                   hold on;
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       subplot(1, length(ind), o), imshow(cropped);
                   end
               end
               
               if(buttonOrder == 51) % press 3 - order by circularity
                   regionCircularities = [imageProps.Circularity];
                   [sorted, ind] = sort(regionCircularities);
                   orderedFigure = figure;
                   hold on;
                   
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       subplot(1, length(ind), o), imshow(cropped);
                   end
                   
                   % compactness = P^2 / A
                   % circularity ratio = 4 pi A / P^2
                   % circularity = P^2 / 4 pi A
                   
               end
               
               if(buttonOrder == 52) % press 4 - order by sharpness
                   regionSharpnesses = [imageProps.Sharpness];
                   [sorted, ind] = sort(regionSharpnesses);
                   orderedFigure = figure;
                   hold on;
                   
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       subplot(1, length(ind), o), imshow(cropped);
                   end
               end
           end
           
       case 97 % Letter a - return the amount of money
           while (true)
               
               % TODO: count cropped coins
               value = 0.0;
               
               for q=1:length(indexes)
                   if (12.3 < imageProps(q).Circularity) && (imageProps(q).Circularity < 12.7)
                       fprintf('COIN\n');
                       val = 0.0;
                       if (coin1CentAO - delta1CentA < imageProps(q).Area) && (imageProps(q).Area < coin1CentAO + delta1CentA)
                           value = value + 0.01
                           val = val + 0.01;
                       end
                       if (coin2CentAO - delta2CentA < imageProps(q).Area) && (imageProps(q).Area < coin2CentAO + delta2CentA)
                           value = value + 0.02
                           val = val + 0.02;
                       end
                       if (coin10CentAO - delta10CentA < imageProps(q).Area) && (imageProps(q).Area < coin10CentAO + delta10CentA)
                           value = value + 0.10
                           val = val + 0.10;
                       end
                       if (coin5CentAO - delta5CentA < imageProps(q).Area) && (imageProps(q).Area < coin5CentAO + delta5CentA)
                           value = value + 0.05
                           val = val + 0.05;
                       end
                       if (coin20CentAO - delta20CentA < imageProps(q).Area) && (imageProps(q).Area < coin20CentAO + delta20CentA)
                           value = value + 0.20
                           val = val + 0.20;
                       end
                       if (coin1EurAO - delta1EurA < imageProps(q).Area) && (imageProps(q).Area < coin1EurAO + delta1EurA)
                           value = value + 1.00
                           val = val + 1.00;
                       end
                       if (coin50CentAO - delta50CentA < imageProps(q).Area) && (imageProps(q).Area < coin50CentAO + delta50CentA)
                           value = value + 0.50
                           val = val + 0.50;
                       end
                       newField = 'Value';
                       imageProps(q).(newField) = val;
                   end
               end
               fprintf('Amount of money:\n')
               value
               break;
           end
           
           
       otherwise
           fprintf('Byeeeee\n');
           close all;
           break;
   end
end





