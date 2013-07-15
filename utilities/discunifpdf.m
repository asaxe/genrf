function p=discunifpdf(x,lower_lim,upper_lim)

p = zeros(size(x));
p = (x >= lower_lim & x <= upper_lim)./(upper_lim-lower_lim+1);