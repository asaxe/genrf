  
 
% Generate data

p=.3; % true value for p
n=100; % number of trials
data=rand(n,1) < .3; % generate data


M=2; % Length of parameter vector theta
N=100;
T=100; % number of iterations
burnin = 50;

delta_prior = 5;

theta=zeros(M,N,T); % declare a vector for storage
x=zeros(N,T);
w=zeros(N,T);

D = sum(data)/n;            



psi=@(p,d) normpdf(p,0,d(2));
simul=@(p) sum(rand(n,1) < p(1))/n;
prior=@(p) unifpdf(p(1))*exppdf(p(2),delta_prior);
samp_prior = @() [unifrnd(0,1); exprnd(delta_prior)];

% initialize
for i = 1:N
    theta(:,i,1) = samp_prior();
    x(i,1) = simul(theta(:,i,1));
    w(i,1) = 1/N;
end


for t = 2:T % loop over iterations
    t
    for i = 1:N
        
        % Crossover update
        theta_t = theta(:,i,t-1);
        
        theta_b = theta(:,randsample(1:N,1,true,w(:,t-1)),t-1);
        tmp = theta(:,randsample(setdiff(1:N,i),2,false),t-1);
        theta_m = tmp(:,1);
        theta_n = tmp(:,2);
        
        gamma_1 = unifrnd(0.5,1);
        gamma_2 = unifrnd(0.5,1);
        b = unifrnd(-.001,.001,M,1);
        
        if t > burnin
            gamma_2 = 0;
        end

        theta_star = theta_t + gamma_1*(theta_m - theta_n) + ...
            gamma_2*(theta_b - theta_t) + b;

        if t > burnin
            theta_star(end) = theta_t(end); % always reset delta
                                           % during sampling
        end
        
       
       
        
        
        
        if prior(theta_star) > 0 % if prior is not > 0, parameters may
                                 % not make sense. no need to continue.
            x_samp = simul(theta_star); % simulate data        
            r = min(1, (psi(D-x_samp,theta_star)*prior(theta_star) ...
                        ) / (psi(D-x(i,t-1),theta_t)* ...
                             prior(theta_t)));
        else
            r = 0;
        end


        if rand() < r
            theta(:,i,t) = theta_star;
            x(i,t) = x_samp;
            
        else
            theta(:,i,t) = theta_t;
            x(i,t) = x(i,t-1);
        end
        
        w(i,t) = prior(theta(:,i,t)) * psi(D-x(i,t),theta(:,i,t));
    end
    w(:,t) = w(:,t)/sum(w(:,t));
    
end

% Graphing
binwidth = .02;
g = 0:binwidth:1;
samps = squeeze(theta(1,:,burnin:end));
posterior=hist(samps(:),g);
bar(g,posterior/sum(posterior)/binwidth,'hist')
hold on
plot(g,betapdf(g,sum(data)+1,n-sum(data)+1),'r','linewidth',2)
