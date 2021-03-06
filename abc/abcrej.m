
 
% Generate data

p=.3; % true value for p
n=100; % number of trials
data=rand(n,1) < .3; % generate data


epsilon=.01;  % tolerance threshold
N=1000; % number of particles
theta=zeros(N,1) % declare a vector for storage
            
rho=@(x,y) abs(sum(x)-sum(y))/n; % rho function


% Run rej sampling alg

for i = 1:N % loop over particles
    i
    % initialize d to be greater than tolerance threshold
    d = epsilon+1;
    while(d>epsilon) 
        theta_samp = rand(1,1); %sample from
                                %uniform prior
                                                        
        x=rand(n,1) < theta_samp; % simulate data
        d=rho(data,x); % compute distance
    end
    theta(i)=theta_samp; % store the accepted value
end

% Graphing
binwidth = .01;
x = 0:binwidth:1;
posterior=hist(theta,x);
bar(x,posterior/sum(posterior)/binwidth,'hist')
hold on
plot(x,betapdf(x,sum(data)+1,n-sum(data)+1),'r','linewidth',2)

%x=seq(0,1,.001)# a grid over the support of theta
%post=dbeta(x,sum(data)+p.alpha,n-sum(data)+p.beta)# true posterior ...
%     density

%xlim=c(0,1)# plotting limits on x-axis
%ylim=c(0,max(post))# plotting limits on y-axis

%hist(theta,xlim=xlim,ylim=ylim,# histogram of the estimate obtained ...
%     using ABC
%main="Posterior Estimate",
%xlab=expression(theta),prob=T,breaks=20)  

%abline(v=p,col="red",lty=2, lwd=3)# true parameter value that generated ...
%         the data
%lines(x,post,lwd=3)# true posterior density

