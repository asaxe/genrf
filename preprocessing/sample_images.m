function x = sample_images(winsize,num_examples)

I=load('~/dat_genrf/datasets/vision/IMAGES_RAW','IMAGESr');
I = I.IMAGESr;

x = zeros(winsize^2,num_examples);

for i = 1:num_examples
    % Sample patches in random locations
    sizex = size(I,2);
    sizey = size(I,1);
    posx = floor(rand()*(sizex-winsize-1))+1;
    posy = floor(rand()*(sizey-winsize-1))+1;
    img = floor(rand()*10)+1;


    x(:,i) = reshape( I(posy:posy+winsize-1, ...
                        posx:posx+winsize-1, img),[winsize^2 ...
                        1]);
end
x = removeDC(x);
