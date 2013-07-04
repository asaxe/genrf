function width = fullWidthAtHalfMaximum(x, y, inOctaves)

	maxValue = max(y);
	halfMax = maxValue / 2;
	nValues = length(x);

	% search for left point
	i = 2;		% lowest point should not be at zero - might cause divide by zero later
	while i<nValues & y(i) <= halfMax
		i = i+1;
	end
	left = x(i);
	if (i == nValues)
		display('Warning: fwhm might not be right: leftHalfwidth=nValues');
		width = -1;
		return;
	end


	% search for cross-over
	while i<nValues-1 & y(i)<maxValue
		i=i+1;
	end

	% search for right point
	while i<nValues & y(i) > halfMax
		i=i+1;
	end
	right = x(i);
	if (i == nValues)
		display('Warning: fwhm might not be right: rightHalfwidth=nValues');
		width = -1;
		return;
	end


%	left
%	right
	if (inOctaves)
		width = log2(right/left);
	else
		width = right - left;
	end


end