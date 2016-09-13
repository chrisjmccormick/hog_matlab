function windowCounts = countWindows(hog, img, scaleRange)
	
	% Get the image dimensions.
    % Make sure to read all three dimensions, or 'origImgWidth' will be 
    % wrong.
    [origImgHeight, origImgWidth, depth] = size(img);
	
	% Initialize the windowCounts array.
	windowCounts = zeros(1, length(scaleRange));
	
    % Try progressively smaller scales until a window doesn't fit.
    for i = 1 : length(scaleRange)
        
		% Get the next scale.
		scale = scaleRange(i);
		
        % Compute the scaled img size.
        imgWidth = origImgWidth * scale;
        imgHeight = origImgHeight * scale;
    
        % Compute the number of cells horizontally and vertically for the image.
        numHorizCells = floor((imgWidth - 2) / hog.cellSize);
        numVertCells = floor((imgHeight - 2) / hog.cellSize);
        
        % Break the loop when the image is too small to fit a window.
        if ((numHorizCells < hog.numHorizCells) || ...
            (numVertCells < hog.numVertCells))
            break;
        end
        
        % The number of windows is not quite equal to the number of cells, since
        % you have to stop when the edge of the detector window hits the edge of
        % the image.
        numHorizWindows = numHorizCells - hog.numHorizCells + 1;
        numVertWindows = numVertCells - hog.numVertCells + 1;
        
        % Compute the number of windows at this image scale.
        windowCounts(1, i) = numHorizWindows * numVertWindows;        
    end

end