function [E X] = vanHaterenComparison(W)
% Compares statistics of bases in rows of W to those measured in
% Macaque V1, as reported in van Haterent et al.
%
% E is a scalar summary metric of the difference
% X is a struct containing the detailed statistics derived from W 
%

winsize = sqrt(size(W,2));

%% Compute statistics
X.sfb = zeros(size(W,1),1);
X.otb = zeros(size(W,1),1);
X.psf = zeros(size(W,1),1);
X.len = zeros(size(W,1),1);
X.ar = zeros(size(W,1),1);
X.or = zeros(size(W,1),1);
 
for i = 1:size(W,1)
     [X.sfb(i) X.otb(i) X.psf(i) X.len(i) X.ar(i) X.or(i)] = gaborStatistics(reshape(W(i,:),winsize,winsize));
end


%% Compare to measured statistics

load ~/genrf/analysis/vision/naturalData.vanHaterenPaper.mat

X.accept = (X.sfb ~= -1) & (X.otb ~= -1) & (X.ar ~= -1) & (X.len ~= -1) & (X.psf ~= -1);

%Check to make sure we didn't throw out too many
if( sum(X.accept)/length(X.accept) < .3 )
    X.exclude = true; 
end


% Compute mean and std dev across restarts for each metric

x = 0:0.2:2.4;
X.sfb_h = histogram(x, X.sfb(X.accept));
X.sfb_L1 = norm(X.sfb_h - sfb_natural(:,2)'/100,1);

x = 10:10:90;
X.otb_h = histogram(x, X.otb(X.accept));
X.otb_L1 = norm(X.otb_h - otb_natural(:,2)'/100,1);

x = 0.15:0.33:3.82;
X.ar_h = histogram(x, X.ar(X.accept));
X.ar_L1 = norm(X.ar_h - asp_natural(:,2)'/100,1);

x = 2.5:5:37.5;
X.len_h = histogram(x, X.len(X.accept)); % Must modify to allow scaling
X.len_L1 = norm(X.len_h - len_natural(:,2)'/100,1);

x = logspace(log10(0.6), log10(9.4), 9);
X.psf_h = histogram(x, X.psf(X.accept)); % Allow scaling?
X.psf_L1 = norm(X.psf_h - psf_natural(:,2)'/100,1);

E = X.sfb_L1 + X.otb_L1 + X.ar_L1 + X.len_L1 + X.psf_L1;
    
end

function y = histogram(x, data)
 
    y = hist(data, x);	% calcuate histogram
    y = y / sum(y);			% normalize
   
end
