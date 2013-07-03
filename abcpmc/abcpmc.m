  
 
% Generate data

p=.3; % true value for p
n=100; % number of trials
data=rand(n,1) < .3; % generate data


epsilon=.01;  % tolerance threshold
N=100;
T=100; % number of iterations
burnin = 30;
theta=zeros(N,T) % declare a vector for storage
x=zeros(N,T);
w=zeros(N,T);
delta = 1;
D = sum(data)/n;            

q=@(x,y,s) normpdf(x,y,s);
samp_q=@(x,s) normrnd(x,s);
pie=@(x,d) normpdf(x,0,d);
simul=@(x) sum(rand(n,1) < x)/n;
prior=@(x) unifpdf(x);
samp_prior = @() unifrnd(0,1);

% initialize
for i = 1:N
    theta(i,1) = samp_prior();
    x(i,1) = simul(theta(1));
    w(i,1) = 1/N;
end
sigma = sqrt(2*var(theta(:,1)));

for t = 2:T % loop over iterations
    t
    for i = 1:N
        theta_star = theta(logical(mnrnd(1,w(:,t-1))'),t-1);
        theta_samp = samp_q(theta_star,sigma);
        x_samp = simul(theta_samp); % simulate data
        r = min(1, (pie(D-x_samp,delta)*q(theta_samp,theta(i,t-1),sigma)*prior(theta_samp) ...
                    ) / (pie(D-x(i,t-1),delta)*q(theta(i,t-1),theta_samp,sigma)* ...
                         prior(theta(i,t-1))));


        if rand() < r
            theta(i,t) = theta_samp;
            x(i,t) = x_samp;
            
        else
            theta(i,t) = theta(i,t-1);
            x(i,t) = x(i,t-1);
        end
        w(i,t) = prior(theta(i,t)) / ( w(:,t-1)'*q(theta(:,t-1), ...
                                                   theta(i,t),sigma) );
    end
    w(:,t) = w(:,t)/sum(w(:,t));
    sigma = sqrt(2*var(theta(:,t)));
    delta = delta / 1.1;
end

% Graphing
binwidth = .02;
g = 0:binwidth:1;
samps = theta(:,burnin:end);
posterior=hist(samps(:),g);
bar(g,posterior/sum(posterior)/binwidth,'hist')
hold on
plot(g,betapdf(g,sum(data)+1,n-sum(data)+1),'r','linewidth',2)
