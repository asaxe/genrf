function precompute_pca_vision(winsize)
rand('seed',winsize)
num_examples = 50000;

x = sample_images(winsize,num_examples);

whitening_file = sprintf(['~/dat_genrf/datasets/vision/' ...
                    'pca_olshausen_%d.mat'],winsize);
[V,E,D] = pca(x);
var = diag(D);
save(whitening_file,'V','var');