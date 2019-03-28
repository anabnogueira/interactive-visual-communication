clear all, close all
img = imread('veiculoGray.jpg');
imshow(img);hold on;
n=0; but=1;
while (but == 1 | but == 32)
    [ci,li,but]=ginput(1);
    but
    if but == 1 % add point
        n = n+1;
        cp(n) = ci;
        lp(n) = li;
        plot(ci,li,'r.', 'MarkerSize', 18); drawnow;
        if n > 1
            plot(cp(:),lp(:),'r.-','MarkerSize',8); drawnow;
        end
    end
end

%A = [1 2;3 4;5 6;7 8]
%A(:,1) returns 1st column
%A(:,2) returns 2nd column
%A(:) returns all as one column

BW = roipoly(img, cp, lp);
ImCrp = img.*uint8(BW);
imagesc(ImCrp); colormap gray

% .* is multiplication/product pixel by pixel

pause