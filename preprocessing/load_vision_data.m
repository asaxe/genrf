function [x,V] = load_vision_data(theta)
% Loads image data with window size theta(1) and whitening
% dimension theta(2)
num_samples = 10000;
winsize = theta(1);
whiteningdim = theta(2);

x = sample_images(winsize,num_samples);

V = load_image_whitening(winsize,whiteningdim);

x = V*x;

 