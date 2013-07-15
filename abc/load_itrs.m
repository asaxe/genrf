function thetas = load_itrs

d = dir('itr*.mat');
load(d(1).name)
N = size(theta,2);
M = size(theta,1);
T = length(d);
thetas = zeros(M,N,T);
for i = 1:T
    load(d(i).name);
    thetas(:,:,t) = theta;
    
end