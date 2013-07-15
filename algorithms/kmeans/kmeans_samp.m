function p = kmeans_samp(N)

window_size = discunifrnd(10,40,1,N);
whitening_dim = discunifrnd(1,window_size.^2,1,N);
num_bases = discunifrnd(1,400,1,N);
delta = exprnd(5,1,N);
     

p = [window_size; whitening_dim; num_bases; delta];