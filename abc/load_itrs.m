function thetas = load_itrs

d = dir('itr*.mat');
T = length(d);
thetas = zeros(2,100,T);
for i = 1:T
    load(d(i).name);
    thetas(:,:,t) = theta;
    
end