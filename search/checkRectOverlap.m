function index = checkRectOverlap(inRect, compRects)
%CHECKRECTOVERLAP Check for overlapping rectangles
%  This function takes an input rectangle 'inRect' and compares it to all
%  of the rectanges in 'compRects' to check for overlap.
%
%  The amount of overlap is calculated as the area of intersection divided
%  by the area of union. If the rectangles are identical, this ratio will
%  be 1.0. For the purpose of validating results, two rectangles are
%  considered overlapping if the ratio is greater than 0.5.
%
%  The input rectangles should be supplied as row vectors with four
%  columns:
%    [top-left-x, top-left-y, width, height]
%
%  The coordinate system is based on a matrix representation of an image,
%  so the top left corner of the image is at (x = 1, y = 1), and the values
%  increase as you move down and to the right.
%
%  Parameters:
%    inRect    - Input rectangle
%    compRects - Matrix of rectangles to compare against (one per row).
%
%  Returns:
%    index - The index (row number) of the first rectangle in compRects 
%            which sufficiently overlaps the input rectangle. Or, -1 if no 
%            overlapping rectangles are found.
%

	% Will return -1 if no overlaping rectangle found.
	index = -1;

	% Get the coordinates of the top-left and bottom-right corners
	% of the rectangle.
	a1x = inRect(1, 1);
    a1y = inRect(1, 2);
    a2x = a1x + inRect(1, 3);
    a2y = a1y + inRect(1, 4);
	
	% Compute the area of the result rectangle.
	aArea = inRect(1, 3) * inRect(1, 4);
	
	% For each of the annotated results...
	for i = 1 : size(compRects, 1)
		% If the rectangles overlap sufficiently...

		% Get the coordinates of the top-left and bottom-right corners
		% of the rectangle.
		b1x = compRects(i, 1);
		b1y = compRects(i, 2);
		b2x = b1x + compRects(i, 3);
		b2y = b1y + compRects(i, 4);
		
		% Copmute the area of the annotated rectangle.
		bArea = compRects(i, 3) * compRects(i, 4);
		
		% Calculate the amount of overlap in the x and y dimensions.
        x_overlap = max(0, min(a2x, b2x) - max(a1x, b1x));
        y_overlap = max(0, min(a2y, b2y) - max(a1y, b1y));

		% Compute the area of intersection (the area of overlap)
		intersectArea = x_overlap * y_overlap;
		
		% Compute the area of union (the areas of non-overlap plus the area of overlap).
		unionArea = aArea + bArea - intersectArea;
		
		% If the area of overlap exceeds 50%, it's a match.
		if ((intersectArea / unionArea) > 0.5)
			index = i;
			return;
		end
		
	end
	
% End function
end