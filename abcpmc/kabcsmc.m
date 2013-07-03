  
 
% Generate data

p=.3; % true value for p
n=100; % number of trials
data=rand(n,1) < .3; % generate data


epsilon=.01;  % tolerance threshold
N=10000; % number of iterations
theta=zeros(N,1) % declare a vector for storage
x=zeros(N,1);
sigma = .3;
delta = .02;
D = sum(data)/n;            

q=@(x,y) normpdf(x,y,sigma);
samp_q=@(x) normrnd(x,sigma);
pie=@(x) normpdf(x,0,delta);
simul=@(x) sum(rand(n,1) < x)/n;
prior=@(x) unifpdf(x);
samp_prior = @() unifrnd(0,1);


theta(1) = samp_prior();
x(1) = simul(theta(1));
for i = 2:N % loop over iterations
    i
        
    theta_samp = samp_q(theta(i-1));
    x_samp = simul(theta_samp); % simulate data
    r = min(1, (pie(D-x_samp)*q(theta_samp,theta(i-1))*prior(theta_samp) ...
            ) / (pie(D-x(i-1))*q(theta(i-1),theta_samp)* ...
                 prior(theta(i-1))));


    if rand() < r
        theta(i) = theta_samp;
        x(i) = x_samp;
    else
        theta(i) = theta(i-1);
        x(i) = x(i-1);
    end
    
end

% Graphing
binwidth = .02;
g = 0:binwidth:1;
posterior=hist(theta,g);
bar(g,posterior/sum(posterior)/binwidth,'hist')
hold on
plot(g,betapdf(g,sum(data)+1,n-sum(data)+1),'r','linewidth',2)
