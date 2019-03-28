clear all
imgbk = imread('database_PED/ped7c0000.tif');

thr = 40;
%minArea = 200; % original
minArea = 100; % mais bounding boxes geradas

baseNum = 1350;
seqLength = 99;

% baseNum = 1374;
% seqLength = 0;
% imshow(imgdif)
se = strel('disk', 3);

%figure;

for i=0:seqLength
    imgfr = imread(sprintf('database_PED/ped7c%.4d.tif', baseNum + i));
    %hold off
    imshow(imgfr); hold on;

    imgdif = ...
        (abs(double(imgbk(:,:,1))-double(imgfr(:,:,1)))>thr) | ...
        (abs(double(imgbk(:,:,2))-double(imgfr(:,:,2)))>thr) | ...
        (abs(double(imgbk(:,:,3))-double(imgfr(:,:,3)))>thr);

    bw = imclose(imgdif, se);
    %subplot(1,2,1); imshow(imgdif); % mostram as regioes da imagem
    %subplot(1,2,2); imshow(bw); % mostram a black and white
    %pause(.001);

    [lb num] = bwlabel(bw);
    regionProps = regionprops(lb, 'area', 'FilledImage', 'Centroid');
    inds = find([regionProps.Area] > minArea);

    regnum = length(inds);
    if regnum
        for j=1:regnum
            [lin col] = find(lb == inds(j));
            upLPoint = min([lin col]);
            dWindow = max([lin col]) - upLPoint + 1;
            rectangle('Position', [fliplr(upLPoint) fliplr(dWindow)],...
                'EdgeColor', [1 1 0], 'linewidth', 2);
        end
    end
    drawnow
end

% Os outliers que representam ruidos devem ser removidos com set operations
% (provavelmente), verificando a continuidade da sua existencia nas imagens