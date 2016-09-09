function windowCounts = countWindows(img, scaleRange)
	% The detector size in number of cells.
	horizCellsPerWindow = 8;
	vertCellsPerWindow = 16;
    cellSize = 8;
	
	% Get the image dimensions.
    [origImgHeight, origImgWidth] = size(img);
	
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
        numHorizCells = floor((imgWidth - 2) / cellSize);
        numVertCells = floor((imgHeight - 2) / cellSize);
        
        % Break the loop when the image is too small to fit a window.
        if ((numHorizCells < horizCellsPerWindow) || ...
            (numVertCells < vertCellsPerWindow))
            break;
        end
        
        % The number of windows is not quite equal to the number of cells, since
        % you have to stop when the edge of the detector window hits the edge of
        % the image.
        numHorizWindows = numHorizCells - horizCellsPerWindow + 1;
        numVertWindows = numVertCells - vertCellsPerWindow + 1;
        
        % Compute the number of windows at this image scale.
        windowCounts(1, i) = numHorizWindows * numVertWindows;        
    end

end