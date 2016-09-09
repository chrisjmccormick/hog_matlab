function [histograms, xoffset, yoffset] = getHistogramsForImage(hog, img)

% =============================
%       Crop The Image
% =============================

[imgHeight, imgWidth] = size(img);

% Compute the number of cells horizontally and vertically for the image.
numHorizCells = floor((imgWidth - 2) / hog.cellSize);
numVertCells = floor((imgHeight - 2) / hog.cellSize);

newWidth = (numHorizCells * 8) + 2;
newHeight = (numVertCells * 8) + 2;

% Divide the left-over pixels in half to center the crop region.
xoffset = round((imgWidth - newWidth) / 2) + 1;
yoffset = round((imgHeight - newHeight) / 2) + 1;

% Crop the image.
img = img(yoffset : (yoffset + newHeight - 1), xoffset : (xoffset + newWidth - 1));

% ===============================
%    Compute Gradient Vectors
% ===============================
% Compute the gradient vector at every pixel in the image.

% Create the operators for computing image derivative at every pixel.
hx = [-1,0,1];
hy = -hx';

% Compute the derivative in the x and y direction for every pixel.
dx = filter2(hx, double(img));
dy = filter2(hy, double(img));

% Remove the 1 pixel border.
dx = dx(2:(newHeight - 1), 2:(newWidth - 1));
dy = dy(2:(newHeight - 1), 2:(newWidth - 1));

% Convert the gradient vectors to polar coordinates (angle and magnitude).
angles = atan2(dy, dx);
magnit = ((dy.^2) + (dx.^2)).^.5;

% =================================
%     Compute Cell Histograms 
% =================================
% Compute the histogram for every cell in the image. We'll combine the cells
% into blocks and normalize them later.

% Create a three dimensional matrix to hold the histogram for each cell.
histograms = zeros(numVertCells, numHorizCells, hog.numBins);

% For each cell in the y-direction...
for row = 0:(numVertCells - 1)
    
    % Compute the row number in the 'img' matrix corresponding to the top
    % of the cells in this row. Add 1 since the matrices are indexed from 1.
    rowOffset = (row * hog.cellSize) + 1;
    
    % For each cell in the x-direction...
    for col = 0:(numHorizCells - 1)
    
        % Select the pixels for this cell.
        
        % Compute column number in the 'img' matrix corresponding to the left
        % of the current cell. Add 1 since the matrices are indexed from 1.
        colOffset = (col * hog.cellSize) + 1;
        
        % Compute the indices of the pixels within this cell.
        rows = rowOffset : (rowOffset + hog.cellSize - 1);
        cols = colOffset : (colOffset + hog.cellSize - 1);
        
        % Select the angles and magnitudes for the pixels in this cell.
        cellAngles = angles(rows, cols); 
        cellMagnitudes = magnit(rows, cols);
    
        % Compute the histogram for this cell.
        % Convert the cells to column vectors before passing them in.
        histograms(row + 1, col + 1, :) = getHistogram(cellMagnitudes(:), cellAngles(:), hog.numBins);
    end
    
end

end
