%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gaborStatistics: This function takes an image patch   %
% as input, approximates it as a gabor filter and	   %
% calculates the gabor's spatial frequency bandwidth	%
% and orientation tuning bandwidth					  %
%
% input: patch, the image patch used
%		visualize, bool if you want pics (optional)
%
% output: sfb is the spatial frequency bandwidth
%		 otb is the orientation tuning bandwidth	   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sfb, otb, psf, len, ar, or] = gaborStatistics( patch, visualize )
    global VISUALIZE;
    VISUALIZE = (nargin == 2) && visualize;
    
    s = size(patch);
   
    expansion_factor = 3;
    big_patch = zeros(s*expansion_factor);
    big_patch(end/3+1:2*end/3,end/3+1:2*end/3) = patch;
    
    
    ft = fftshift(fft2(big_patch));
    f = abs(ft);
		
    optPoint = findOptimalPoint(f);
    midPoint = findMidPoint(f);
    
    
    diff = optPoint - midPoint;
    sf = norm(diff);
    theta = atan2(diff(2),diff(1));
    
	
    sfb = spatialFrequencyBandwidth(f, optPoint, midPoint);
    otb = orientationTuningBandwidth(f, optPoint, midPoint);
    %psf = peakSpatialFrequency(optPoint);
    psf = norm(optPoint-midPoint)/expansion_factor;
    
    envelope = computeEnvelope(patch);
	
    eMidPoint = findOptimalPointFull(envelope);
    diff = optPoint - midPoint;
    diff2 = [-diff(2); diff(1)];
    p1 = eMidPoint + diff;
    p2 = eMidPoint + diff2;
   
    len = length(envelope, eMidPoint, p2);
    width = length(envelope, eMidPoint, p1);
    ar = len / width;
    
    or = atan2(diff(2),diff(1)) + pi/2;
    
    x = eMidPoint(1);
    y = eMidPoint(2);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%						 CALCULATE ENVELOPE							  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function e = computeEnvelope(patch)
    global VISUALIZE;
	
	% find the hilbert transform of the measured signal
        % NOTE: This is the 1D transform which is better than nothing but not
        % what you really want
	signal_h = hilbert(patch);


	% square the hilbert transform and take the
	% +ve square root to get the estimated envelope
	e = sqrt(signal_h.*conj(signal_h));
	
	if(VISUALIZE)
		figure;
		subplot(221);
		imagesc(real(signal_h));
		subplot(222);
		imagesc(imag(signal_h));
		subplot(223);
		imagesc(e);
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					   CALCULATE STATISTICS							  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function psf = peakSpatialFrequency(optPoint)
	psf = norm(optPoint);
end

function l = length(f, optPoint, midPoint)
    global VISUALIZE;
    SLOPE_LENGTH = 0.1;
    dataElems = ceil(size(f, 1) / SLOPE_LENGTH);
    dataElems = ceil(sqrt(dataElems * dataElems * 2));
    
    x =  (0 : dataElems - 1) * SLOPE_LENGTH;
    y = zeros(1, dataElems);
	
    if (VISUALIZE)
        lineImage = zeros(size(f, 1));
    end
	
    if(midPoint == optPoint)
        l = -1;
        return;
    end
    
    slope = findSlope(midPoint, optPoint, SLOPE_LENGTH);
    slopeC = slope(2) / slope(1);
    curr = zeros(2, 1);
    curr(2) = midPoint(2) - slopeC * midPoint(1);
	
    if (slopeC == Inf)
        slope(1) = 0.0001;
        slopeC = slope(2) / slope(1);
        curr = zeros(2, 1);
        curr(2) = midPoint(2) - slopeC * midPoint(1);
    end
	
    if(slope(1) < 0)
        slope = -slope;
    end
    i = 1;
    while(i <= dataElems) 
        row = round(curr(1));
        col = round(curr(2));
        if (row > size(f, 1))
            break;
        elseif(row< 1 || col < 1 || col > size(f, 1))
            curr = curr + slope;
            continue;
        end
        
        if (VISUALIZE)
            lineImage(row, col) = 1;
        end
            
        y(i) = f(row, col);
        i = i + 1;
        curr =  curr + slope;
    end
    
    if(VISUALIZE)
        figure;
        subplot(221);
        imagesc(f);
        subplot(222);
        imagesc(lineImage);
        subplot(223);
        plot(x, y);
    end
 
    l = fullWidthAtHalfMaximum(x, y, false);
 
end


function otb = orientationTuningBandwidth(f, optPoint, midPoint)
    global VISUALIZE;
    ARC_LENGTH = 0.01;
    dataElems = ceil(pi / ARC_LENGTH);
    
    % x is the degrees tested (0 through 180)
    % y(i) is the value of f at x(i) degrees
    x =  (0 : dataElems - 1) * ARC_LENGTH * 180/pi;
    y = zeros(1, dataElems);
    
    if (VISUALIZE)
        circleImage = zeros(size(f, 1));
    end
    
    radius = norm(optPoint - midPoint);
    
    
    if (radius == 0)
        otb = -1;
        return;
    end
    
    startangle = -pi/2 + 2*pi-atan((optPoint(1)-midPoint(1))/(optPoint(2)-midPoint(2)));
    if startangle>=2*pi
        startangle = startangle - 2*pi;
    end
    angle = startangle;
    
    
    i = 1;
    while(i <= dataElems)
        col = round(cos(angle) * radius + midPoint(2));
        row = round(midPoint(1) - sin(angle) * radius);
        if (row > size(f, 1) || col > size(f, 1))
            y(i) = 0;
        elseif (row < 1 || col < 1)
            y(i) = 0;
        else
            y(i) = f(row, col);
            if (VISUALIZE)
                %if radius < 10
                %	plotr = 10;
                %else
                plotr = radius;
                %end
                plotcol = round(cos(angle) * plotr + midPoint(2));
                plotrow = round(midPoint(1) - sin(angle) * plotr);
                if (plotrow < 1)
                    plotrow = 1;
                end
                if (plotcol < 1)
                    plotcol = 1;
                end
                circleImage(plotrow, plotcol) = 1;
            end
        end

        x(i) = (angle - startangle)*180/pi;
        angle = angle + ARC_LENGTH;
        i = i + 1;
        
    end
	
    if(VISUALIZE)
        figure;
        subplot(131);
        imagesc(f);
        subplot(132);
        imagesc(circleImage);
        subplot(133);
        plot(x, y);
    end
    
    %otb = fwhm(x, y);
    otb = fullWidthAtHalfMaximum(x, y, false);
    
    if(otb > 90)
        otb = otb / 2;
    end
    
end

function sfb = spatialFrequencyBandwidth(f, optPoint, midPoint)
    global VISUALIZE;
    SLOPE_LENGTH = 0.1;
    dataElems = ceil(size(f, 1) / SLOPE_LENGTH);
    
    x =  (0 : dataElems - 1) * SLOPE_LENGTH;
    y = zeros(1, dataElems);
    
    if (VISUALIZE)
        lineImage = zeros(size(f, 1));
    end
    
    slope = findSlope(midPoint, optPoint, SLOPE_LENGTH);
    
    if(slope(1) == inf || isnan(slope(1)))
        sfb = -1;
        return;
    end
    
    curr = midPoint;
    i = 1;
    while(i <= dataElems) 
        row = round(curr(1));
        col = round(curr(2));
        if (row > size(f, 1) || col > size(f, 2))
            break;
        elseif (row < 1 || col < 1)
            break;
        end
        
        if (VISUALIZE)
            lineImage(row, col) = 1;
        end
        
        if(isnan(row) || isnan(col))
            display('asdfs');
        end
        
        y(i) = f(row, col);
        i = i + 1;
        curr =  curr + slope;
    end
    
    if(VISUALIZE)
        figure;
        subplot(131);
        imagesc(f);
        subplot(132);
        imagesc(lineImage);
        subplot(133);
        plot(x, y, 'b-o');
    end
    %sfb = octaveFwhm(x, y);
    sfb = fullWidthAtHalfMaximum(x, y, true);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%					   GENERAL HELPER METHODS							%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function point = findMidPoint(F)
    midValue = ceil((size(F, 1) + 1) / 2);
    point = ones(2, 1);
    point(1) = midValue;
    point(2) = midValue;
end

function point = findOptimalPoint(F)
    halfRow = ceil((size(F, 1) + 1) / 2);
    topHalf = F(1 : halfRow, :);
    [colMax rowMaxIndex] = max(topHalf);
    [rowMax colMaxIndex] = max(colMax);
    
    col = colMaxIndex;
    row = rowMaxIndex(colMaxIndex);
    
    point = ones(2, 1);
    point(1) = row;
    point(2) = col;
end

function slope = findSlope(p1, p2, desiredLength) 
    slope = p2 - p1;
    actualLength = norm(slope);
    scale = desiredLength / actualLength;
    slope = slope * scale;
end

function point = findOptimalPointFull(F)
    [colMax rowMaxIndex] = max(F);
    [rowMax colMaxIndex] = max(colMax);

    col = colMaxIndex;
    row = rowMaxIndex(colMaxIndex);
	
    point = ones(2, 1);
    point(1) = row;
    point(2) = col;
end