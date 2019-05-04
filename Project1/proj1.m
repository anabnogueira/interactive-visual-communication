close all, clear all

mlPath = pwd;

% Parameters
threshold = 120;
minimumArea = 6;
erosionRadius = 7;
dilationRadius = 3;

% Processing training image
originalImg = imread('Moedas/Moedas1.jpg');

grayscaleRed = originalImg(:,:,1);
bw = grayscaleRed > threshold;

[lb, num] = bwlabel(bw);

coinProps = regionprops(lb, 'Area', 'Perimeter');
coinProps(end) = [];

areas = sort([coinProps.Area]);
perimeters = sort([coinProps.Perimeter]);

% Coin areas before Opening
coin1CentA = areas(:,1);
coin2CentA = areas(:,2);
coin10CentA = areas(:,3);
coin5CentA = areas(:,4);
coin20CentA = areas(:,5);
coin1EurA = areas(:,6);
coin50CentA = areas(:,7);

% Opening Operation
seEr = strel('disk', erosionRadius);
seOp = strel('disk', dilationRadius);
erosionImage = imerode(bw, seEr);
openImage = imdilate(erosionImage, seOp);

[lbO, numO]=bwlabel(openImage);

coinPropsOpened = regionprops(lbO, 'Area', 'Perimeter');
coinPropsOpened(end) = [];

areasO = sort([coinPropsOpened.Area]);
perimetersO = sort([coinPropsOpened.Perimeter]);

% Coin Areas after Opening
coin1CentAO = areasO(:,1);
coin2CentAO = areasO(:,2);
coin10CentAO = areasO(:,3);
coin5CentAO = areasO(:,4);
coin20CentAO = areasO(:,5);
coin1EurAO = areasO(:,6);
coin50CentAO = areasO(:,7);

% Deltas
delta1CentA = (coin1CentA - coin1CentAO) * dilationRadius / erosionRadius;
delta2CentA = (coin2CentA - coin2CentAO) * dilationRadius / erosionRadius;
delta10CentA = (coin10CentA - coin10CentAO) * dilationRadius / erosionRadius;
delta5CentA = (coin5CentA - coin5CentAO) * dilationRadius / erosionRadius;
delta20CentA = (coin20CentA - coin20CentAO) * dilationRadius / erosionRadius;
delta1EurA = (coin1EurA - coin1EurAO) * dilationRadius / erosionRadius;
delta50CentA = (coin50CentA - coin50CentAO) * dilationRadius / erosionRadius;


fprintf('\n--------------------------------------------------------------------\n')
fprintf('                              Insert Coins\n')
fprintf('--------------------------------------------------------------------\n\n')

fprintf('Choose one of the following commands to proceeed:\n\n')

fprintf('\t1 - Choose image samples from collection\n\n')
fprintf('\t2 - Choose your own image from directory\n\n')
fprintf('\t3 - Exit\n\n\n')

fprintf('Type the number of the command you wish:\n\n')
command = input('>> ');

% Check the chosen command
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
        
        % Try to open file specified
        try
            imgPath = strcat(mlPath,'/',filename);
            originalImage = imread(imgPath);
        catch
            fprintf('\nERROR: File not found in directory!\n\n')
        end

    case 3
        fprintf('\nBye!\n\n')
        return
end

% Process chosen image
grayscaleRedOriginal = originalImage(:,:,1);
bwOriginal = grayscaleRedOriginal > threshold;

imageEroded = imerode(bwOriginal, seEr);
imageOpened = imdilate(imageEroded, seOp);

[labelsOpened, numOp] = bwlabel(imageOpened);
imageProps = regionprops(labelsOpened, 'Area', 'Perimeter', 'Centroid', 'FilledImage', 'BoundingBox');
indexes = find([imageProps.Area] > minimumArea);

% Compute and add fields to imageProps
newField = 'Circularity';
for a=1:length(indexes)
   imageProps(a).(newField) = (4 * pi * imageProps(a).Area) / ((imageProps(a).Perimeter).^2);
end

newField = 'Sharpness';                   
for a=1:length(indexes)
   [Gx, Gy] = gradient(imageProps(a).FilledImage);
   S = sqrt(Gx.*Gx+Gy.*Gy);
   sharpness = sum(sum(S))./(numel(Gx));
   imageProps(a).(newField) = sharpness;
end

% Open Image
figure('Name','Original Image'), hold on, imshow(originalImage, 'InitialMagnification', 'fit');
[height, width, dim] = size(originalImage);
set(gcf, 'Position', [100 100 1000 500]);

% Show available commands - general
commands = {'Press:', 'n - nr of objects', 'm - measurements of objects', 'd - distances between objects',...
'g - derivatives graph', 'o - order by parameter', 'a - count amount of money', 's - order by similarity',...
'h - show histogram', 'x - show heatmap', ' ', 'q - quit'};

commandsText = strjoin(commands, '\n');

% Show available commands for each menu
commandsM = {'Click object to show', 'measurements', ' ', 'Press:', 'q - quit'};
commandsMText = strjoin(commandsM, '\n');

commandsD = {'Click objects to show', 'distances', ' ', 'Press:', 'r - reset image', 'q - quit'};
commandsDText = strjoin(commandsD, '\n');

commandsG1 = {'Click object', ' ', 'Press:', 'q - quit'};
commandsG1Text = strjoin(commandsG1, '\n');
commandsG2 = {'Choose number of points', 'in the console'};
commandsG2Text = strjoin(commandsG2, '\n');

commandsO = {'Select parameter to order by:', '1 - Area', '2 - Perimeter',...
    '3 - Circularity', '4 - Sharpness'};
commandsOText = strjoin(commandsO, '\n');

commandsS1 = 'Select one object';
commandsS2 = 'Objects most similar to chosen object';

commandsH = {'Press:', 'q - quit'};
commandsHText = strjoin(commandsH, '\n');


% Program start
while(true)
   % Position textbox
   t = text(width + 50, 200, commandsText, 'FontWeight', 'bold');

   % Textbox formatting
   t.BackgroundColor = 'w';
   t.Color = 'k';
   t.FontSmoothing = 'on';
   t.FontSize = 13;
   t.Margin = 5;
   
   [x, y, button] = ginput(1);
   
   switch button
       
       case 113 % if q is pressed, quit
           close all;
           break;
           
           
       case 110 % Letter n - show number of objects contained in image
           fprintf('Number of Objects detected: ' + string(length(indexes)) + '\n');
           
           
       case 109 % Letter m - show coin/object measurements
           hold on
           delete(t);
           tM = text(width + 50, 200, commandsMText, 'FontWeight', 'bold');

           % Textbox formatting
           tM.BackgroundColor = 'w';
           tM.Color = 'k';
           tM.FontSmoothing = 'on';
           tM.FontSize = 13;
           tM.Margin = 5;
           
           for i=1:length(indexes)
               [B, L, N] = bwboundaries(imageOpened);

               % Plot object boundaries          
               for a=1:length(B)
                   boundary = B{a};
                   if(a > N)
                       plot(boundary(:,2), boundary(:,1), 'w--', 'LineWidth', 3);
                   else
                       plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth',4);
                   end
               end
               
               % Plot centroids
               plot(imageProps(indexes(i)).Centroid(1),imageProps(indexes(i)).Centroid(2),'rx', 'LineWidth', 21)
           end
           
           while(true)
               % Waits for user to select one region
               [xm, ym, buttonm] = ginput(1);
               
               if (buttonm == 113) % Press q to quit
                       delete(tM);
                       imshow(originalImage);
                       break;
               end
               
               if (buttonm == 1)
                   ret = labelsOpened(round(ym),round(xm));
                   if (ret ~= 0)
                       xr = imageProps(ret).Centroid(1);
                       yr = imageProps(ret).Centroid(2);

                       % Region information
                       regionText = strcat('Region #', num2str(ret));
                       areaText = {'Area:', num2str(imageProps(ret).Area)};
                       areaTextCat = strjoin(areaText, ' '); 
                       perimeterText = {'Perimeter:', num2str(imageProps(ret).Perimeter)};
                       perimeterTextCat = strjoin(perimeterText, ' ');
                       legendText = {regionText, areaTextCat, perimeterTextCat}; 
                       legendTextCat = strjoin(legendText, '\n');

                       % Position textbox
                       t = text(xr-200-imageProps(ret).Perimeter/(2*pi), yr-imageProps(ret).Perimeter/(2*pi), legendTextCat, 'FontSize', 12,'FontWeight', 'bold');

                       % Textbox formatting
                       t.BackgroundColor = 'w';
                       t.Color = 'k';
                       t.FontSmoothing = 'on';
                       t.FontSize = 10;
                       t.Margin = 5;
                   end
               end
           end
           
           
       case 100 % Letter d - compute distances
           delete(t);
           tD = text(width + 50, 200, commandsDText, 'FontWeight', 'bold');

           % Textbox formatting
           tD.BackgroundColor = 'w';
           tD.Color = 'k';
           tD.FontSmoothing = 'on';
           tD.FontSize = 13;
           tD.Margin = 5;
           
           while(true)
               [xm, ym, buttond] = ginput(1);
               
               if (buttond == 113) % Press q to quit
                       delete(tD);
                       imshow(originalImage);
                       break;
               end
               
               if (buttond == 114) % Press r to reset
                       imshow(originalImage);
               end
               
               if (buttond == 1)
                   hold on
                   
                   % Object that was clicked on
                   ret = labelsOpened(round(ym),round(xm));
                   
                   if (ret ~= 0)
                       % Compute distance between objects
                       listDistance = struct('Distance', {}, 'Index', {});
                       for a=1:length(indexes)
                           if(a ~= ret)
                               x1 = imageProps(ret).Centroid(1);
                               y1 = imageProps(ret).Centroid(2);
                               x2 = imageProps(indexes(a)).Centroid(1);
                               y2 = imageProps(indexes(a)).Centroid(2);
                               distance = sqrt((x1-x2).^2 + (y1-y2).^2);

                               % Add distance to struct
                               sim = struct('Distance', distance, 'Index', indexes(a));
                               listDistance = [listDistance ; sim];
                           end
                       end

                       [sorted, ind] = sort([listDistance.Distance]);
                       
                       for a=1:length(ind)
                           x1 = imageProps(ret).Centroid(1);
                           y1 = imageProps(ret).Centroid(2);
                           x2 = imageProps(listDistance(ind(a)).Index).Centroid(1);
                           y2 = imageProps(listDistance(ind(a)).Index).Centroid(2);
                           plot([round(x1) round(x2)], [round(y1) round(y2)], 'k', 'LineWidth', 0.5 + 0.8 * a);
                           plot(x2, y2, 'ro', 'LineWidth', 6);
                       end
                       % Plot centroid of chosen region
                       plot(imageProps(ret).Centroid(1), imageProps(ret).Centroid(2), 'ro', 'LineWidth', 6);
                   end
               end             
           end
           
           
       case 103 % Letter g - show boundary derivative graph
           delete(t);
           tG1 = text(width + 50, 200, commandsG1Text, 'FontWeight', 'bold');

           % Textbox formatting
           tG1.BackgroundColor = 'w';
           tG1.Color = 'k';
           tG1.FontSmoothing = 'on';
           tG1.FontSize = 13;
           tG1.Margin = 5;
           
           while(true)
               % Waits for user to select region
               [xb, yb, buttonG] = ginput(1);
               
               if (buttonG == 1)
                   ret = labelsOpened(round(yb),round(xb));

                   if (ret ~= 0)
                       hold on
                       [B,L,N] = bwboundaries(imageOpened);
                       boundary = B{ret};

                       plot(boundary(:,2), boundary(:,1), 'k--', 'LineWidth', 4);

                       delete(tG1);
                       tG2 = text(width + 50, 200, commandsG2Text, 'FontWeight', 'bold');

                       % Textbox formatting
                       tG2.BackgroundColor = 'w';
                       tG2.Color = 'k';
                       tG2.FontSmoothing = 'on';
                       tG2.FontSize = 13;
                       tG2.Margin = 5;

                       % Gets number of points to show in boundary from console
                       fprintf('\nChoose number of points:\n');
                       nrPoints = input('>> ');             

                       % Compute step to use when traversing matrix
                       step = round(length(B{ret})/nrPoints);
                       index = 1;
                       a = [];
                       b = [];

                       % Plot points over boundary
                       for l=1:nrPoints
                           plot(B{ret}(index,2), B{ret}(index,1),'ro', 'LineWidth', 3);
                           a = [a ; B{ret}(index,2), B{ret}(index,1)];
                           index = index + step;
                       end

                       % Determine derivative between chosen points
                       for m=1:length(a)
                           % Check if it is the last el
                           % Determine derivative between last and first el
                           if(a(end,:) == a(m,:))
                              slope = (a(1,2) - a(m,2))/(a(1,1) - a(m,1));
                              b = [b ; slope]; 
                              break;
                           end
                           slope = (a(m+1,2) - a(m,2))/(a(m+1,1) - a(m,1));
                           b = [b ; slope];
                       end

                       % Create graph
                       graphFigure = figure('Name', 'Derivative graph');
                       a(end,:) = [];
                       x = [1:1:length(b)];
                       x = x.';
                       y = b;
                       graph = plot(x,y);
                       % Format graph
                       graph.LineWidth = 2;
                       graph.Color = 'r';
                       ax = gca;
                       ax.XAxisLocation = 'origin'; 

                       % Wait for input on graph window
                       [xg, yg, buttonGraph] = ginput(1);
                       if (buttonGraph == 113)
                           close(graphFigure);
                       end

                       delete(tG2);

                       points = findobj('type','line');
                       delete(points);
                       t = text(width + 50, 200, commandsG1Text, 'FontWeight', 'bold');

                       % Textbox formatting
                       t.BackgroundColor = 'w';
                       t.Color = 'k';
                       t.FontSmoothing = 'on';
                       t.FontSize = 13;
                       t.Margin = 5;
                       
                   end
               end       
               
               if (buttonG == 113) % Press q to quit
                   imshow(originalImage);
                   break;
               end
           end
           
       case 111 % Letter o - order by different parameters
           
           delete(t);
           tO = text(width + 50, 200, commandsOText, 'FontWeight', 'bold');

           % Textbox formatting
           tO.BackgroundColor = 'w';
           tO.Color = 'k';
           tO.FontSmoothing = 'on';
           tO.FontSize = 13;
           tO.Margin = 5;
           
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
               
               if(buttonOrder == 49) % Press 1 - order by area
                   regionAreas = [imageProps.Area];
                   [sorted, ind] = sort(regionAreas);
                   orderedFigure = figure('Name','Objects ordered by Area', 'Position', [10 10 1200 800]);
                   hold on;
                   ax = [];
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       if (o~=1)
                           imgResized = imresize(cropped, (1 + (o * 0.06)));
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                       if (o==1)
                           imgResized = imresize(cropped, o);
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                   end
                   linkaxes(ax, 'x');
               end
               
               if(buttonOrder == 50) % Press 2 - order by perimeter
                   regionPerimeters = [imageProps.Perimeter];
                   [sorted, ind] = sort(regionPerimeters);
                   orderedFigure = figure('Name','Objects ordered by Perimeter', 'Position', [10 10 1200 800]);
                   hold on;
                   
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       if (o~=1)
                           imgResized = imresize(cropped, (1 + (o * 0.06)));
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                       if (o==1)
                           imgResized = imresize(cropped, o);
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                   end
                   linkaxes(ax, 'x');
               end
               
               if(buttonOrder == 51) % Press 3 - order by circularity
                   regionCircularities = [imageProps.Circularity];
                   [sorted, ind] = sort(regionCircularities);
                   orderedFigure = figure('Name', 'Objects ordered by Circularity');
                   hold on;
                   
                   for o=1:length(ind)
                       boundingBox = imageProps(ind(o)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       if (o~=1)
                           imgResized = imresize(cropped, (1 + (o * 0.06)));
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                       if (o==1)
                           imgResized = imresize(cropped, o);
                           ax(o) = subplot(1, length(ind), o); imshow(imgResized);
                       end
                   end
                   linkaxes(ax, 'x');                
               end
               
               if(buttonOrder == 52) % press 4 - order by sharpness
                   [B,L,N] = bwboundaries(imageOpened);
                   nrPoints = 30;
                   sharpnesses = [];
                   
                   for a=1:length(B)
                       aBoundary = [];
                       step = round(length(B{a})/nrPoints);
                       index = 1;

                       for l=1:nrPoints
                           if((B{a}(index,2) ~= 1) && (B{a}(index,1) ~=1) && (B{a}(index,1) ~= height) && (B{a}(index,2) ~= width))
                               plot(B{a}(index,2), B{a}(index,1),'ro', 'LineWidth', 3);                           
                               aBoundary = [aBoundary ; B{a}(index,2), B{a}(index,1)];
                           end
                           index = index + step;
                       end

                       ddA = diff(aBoundary(:,1),2);
                       
                       sharpnesses = [sharpnesses ; max(abs(ddA)), a];
                   end
                   
                   sharpnesses = sortrows(sharpnesses, 1);
                   orderedFigure = figure('Name','Objects ordered by Sharpness', 'Position', [10 10 1200 800]);
                   hold on;
                   
                   axisvec = [];
                   for i=length(sharpnesses):-1:1
                       boundingBox = imageProps(sharpnesses(i,2)).BoundingBox;
                       cropped = imcrop(originalImage, boundingBox);
                       if (i~=length(sharpnesses))
                           imgResized = imresize(cropped, i);
                           axisvec(i) = subplot(1, length(sharpnesses), i); imshow(imgResized);
                       end
                       if (i==length(sharpnesses))
                           imgResized = imresize(cropped, i);
                           axisvec(i) = subplot(1, length(sharpnesses), i); imshow(imgResized);
                       end
                   end
                   linkaxes(axisvec, 'x');
               end
           end
           
       case 97 % Letter a - return the amount of money
           delete(t);
           
           while (true)
               
               % Total Value
               value = 0.0;
               
               for q=1:length(indexes)
                   if (0.98 < imageProps(q).Circularity) && (imageProps(q).Circularity < 1.1)
                       % Value of current coin
                       val = 0.0;
                       if (coin1CentAO - delta1CentA < imageProps(q).Area) && (imageProps(q).Area < coin1CentAO + delta1CentA)
                           value = value + 0.01;
                           val = val + 0.01;
                       end
                       if (coin2CentAO - delta2CentA < imageProps(q).Area) && (imageProps(q).Area < coin2CentAO + delta2CentA)
                           value = value + 0.02;
                           val = val + 0.02;
                       end
                       if (coin10CentAO - delta10CentA < imageProps(q).Area) && (imageProps(q).Area < coin10CentAO + delta10CentA)
                           value = value + 0.10;
                           val = val + 0.10;
                       end
                       if (coin5CentAO - delta5CentA < imageProps(q).Area) && (imageProps(q).Area < coin5CentAO + delta5CentA)
                           value = value + 0.05;
                           val = val + 0.05;
                       end
                       if (coin20CentAO - delta20CentA < imageProps(q).Area) && (imageProps(q).Area < coin20CentAO + delta20CentA)
                           value = value + 0.20;
                           val = val + 0.20;
                       end
                       if (coin1EurAO - delta1EurA < imageProps(q).Area) && (imageProps(q).Area < coin1EurAO + delta1EurA)
                           value = value + 1.00;
                           val = val + 1.00;
                       end
                       if (coin50CentAO - delta50CentA < imageProps(q).Area) && (imageProps(q).Area < coin50CentAO + delta50CentA)
                           value = value + 0.50;
                           val = val + 0.50;
                       end
                       newField = 'Value';
                       imageProps(q).(newField) = val;
                   end
               end
               
               values = {num2str(value), char(8364)};
               valueText = strjoin(values, ' ');
               commandsA = {'Amount of money in image:', valueText, ' ', 'Press:', 'q - quit'};
               commandsAText = strjoin(commandsA, '\n');
               
               tA = text(width + 50, 200, commandsAText, 'FontWeight', 'bold');

               % Textbox formatting
               tA.BackgroundColor = 'w';
               tA.Color = 'k';
               tA.FontSmoothing = 'on';
               tA.FontSize = 13;
               tA.Margin = 5;
               
               [xo, yo, buttonA] = ginput(1);
               
               if (buttonA == 113) % Press q to quit
                   delete(tA);
                   imshow(originalImage);
                   break;
               end
           end
           
       case 115 % Letter s - show coins according to a similarity measure
           
           delete(t);
           while(true)
               
               tS1 = text(width + 50, 200, commandsS1, 'FontWeight', 'bold');

               % Textbox formatting
               tS1.BackgroundColor = 'w';
               tS1.Color = 'k';
               tS1.FontSmoothing = 'on';
               tS1.FontSize = 13;
               tS1.Margin = 5;
               
               % Waits for user to select one region
               [xm, ym, buttonS] = ginput(1);
               
               if (buttonS == 113) % Press q to quit
                   imshow(originalImage);
                   break;
               end
               
               if (buttonS == 1)
                   ret = labelsOpened(round(ym),round(xm));
                   if (ret ~= 0)
                       
                       % Using Circularity as a measure
                       % Initialise struct to contain similarity values
                       listSimilarity = struct('Similarity', {}, 'Index', {});
                       
                       for r=1:length(indexes)
                           if(r ~= ret)
                               similarity = abs(imageProps(r).Circularity - imageProps(ret).Circularity);
                               
                               % Add similarity and index to struct
                               sim = struct('Similarity', similarity, 'Index', indexes(r));
                               listSimilarity = [listSimilarity ; sim];
                           end
                       end
                           
                       [sorted, ind] = sort([listSimilarity.Similarity]);
                       similarityFigure = figure('Name','Similarity between objects');
                        
                       hold on;

                       for o=1:length(ind)
                           boundingBox = imageProps(listSimilarity(ind(o)).Index).BoundingBox;
                           cropped = imcrop(originalImage, boundingBox);
                           subplot(1, length(ind), o), imshow(cropped);
                       end
                       
                       [xm, ym, buttonS2] = ginput(1);
                       
                       if (buttonS2 == 113) % Press q to quit
                           close(similarityFigure);
                           delete(tS1);
                           imshow(originalImage);
                           break;
                       end

                       if (buttonS2 == 114) % Press r to reset
                           close(similarityFigure);
                       end
                       
                   end
               end
           end
           
       case 104 % Letter h - show histogram for RGB image
           
           histogram = figure('Name', 'Histogram for RGB image', 'Position', [10 10 1000 700]); hold on;
           % x axis is intensity on the channel
           % y axis is the frequency of pixels for each channel
           lineR = plot(imhist(originalImage(:,:,1)), 'r'); 
           lineG = plot(imhist(originalImage(:,:,2)), 'g');
           lineB = plot(imhist(originalImage(:,:,3)), 'b'); 
           lineR.LineWidth = 2;
           lineG.LineWidth = 2;
           lineB.LineWidth = 2;
           hold off;
           tH = text(305, 18000, commandsHText, 'FontWeight', 'bold');

           % Textbox formatting
           tH.BackgroundColor = 'w';
           tH.Color = 'k';
           tH.FontSmoothing = 'on';
           tH.FontSize = 13;
           tH.Margin = 5;
               
           while(true)
               [xm, ym, buttonAfter] = ginput(1);
               if (buttonAfter == 113) % Press q to quit
                   close(histogram);
                   imshow(originalImage);
                   break;
               end
           end
       
       case 120 % Letter x - show heatmap regions
           while(true)
               listDistance = struct('Distance', {}, 'Index', {});
               for a=1:length(indexes)
                   tX = text(imageProps(a).Centroid(1)-7, imageProps(a).Centroid(2)-7, num2str(a), 'FontWeight', 'bold');
                   tX.Color = 'k';
                   tX.FontSmoothing = 'on';
                   tX.FontSize = 18;
                   
                   for b=1:length(indexes)
                       x1 = imageProps(a).Centroid(1);
                       y1 = imageProps(a).Centroid(2);
                       x2 = imageProps(b).Centroid(1);
                       y2 = imageProps(b).Centroid(2);
                       distance = sqrt((x1-x2).^2 + (y1-y2).^2);
                       matrix(a,b) = distance;
                   end
               end
               pause(3);
               xvalues = [1:1:length(indexes)];
               yvalues = [1:1:length(indexes)];
               hm = HeatMap(matrix, 'ColumnLabels', xvalues, 'RowLabels', yvalues, 'Symmetric', 'false', 'ColumnLabelsRotate', 0);
               hm.Colormap = 'parula';
               
               [xm, ym, buttonAfter] = ginput(1);
               if (buttonAfter == 113) % Press q to quit
                   imshow(originalImage);
                   break;
               end
           end
           
       otherwise
           continue;
   end
end





