function V = load_image_whitening(winsize, whiteningdim)

whitening_file = sprintf(['~/dat_genrf/datasets/vision/' ...
                    'pca_olshausen_%d.mat'],winsize);

load(whitening_file,'V');

V = V(1:whiteningdim,:);