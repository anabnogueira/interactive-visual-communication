clear all, close all

img = imread('images/veiculoGray.jpg');

% hold on holds current graph, plot, axis etc.

imshow(img); hold on;

n = 0; but = 1;
while (but == 1 | but == 32)
    
    % ginput(N) - graphical input from mouse
    %   gets N points from the current axes and returns X,Y coordinates
    %   in length N vectors X and Y
    %   Click enter to terminate the mouse input
    
    [ci,li,but] = ginput(1);
    
    % if no semicolon is used, just prints the value of but
    but;
    
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