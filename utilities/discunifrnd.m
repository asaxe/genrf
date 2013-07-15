function y=discunifrnd(lower_lim, upper_lim, M, N);

y = unidrnd(upper_lim-lower_lim+1, M, N)+lower_lim-1;

