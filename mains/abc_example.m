% Parameters governing data
flip_prob = .3;
n = 100;
data = rand(n,1) < flip_prob;
D = sum(data)/n;

% Parameters governing priors
delta_prior = 5;

expt_dir = 'test5';


% Necessary function pointers
psi = @(p,d) normpdf(p,0,d(2,:));
simul = @(p,pid) abc_examp_simul(p,pid,n,D);
prior = @(p) unifpdf(p(1,:)).*exppdf(p(2,:),delta_prior);
samp_prior = @(np) [unifrnd(0,1,1,np); exprnd(delta_prior,1,np)];

cwd = pwd;
expt_path = ['~/dat_genrf/abcde_test/' expt_dir];
mkdir(expt_path);
cd(expt_path);

% Parameters governing abcde
N = 100;
T = 100;
burnin = 50;
freeze_mask = 2; % Indicates that parameter 2 should be frozen
                 % after the burnin period, since parameter 2 is delta

abcde(psi,simul,prior,samp_prior, N, T, burnin, freeze_mask)

theta=load_itrs;
save('theta.mat','theta','burnin','data')
cd(cwd)

% Graphing
binwidth = .02;
g = 0:binwidth:1;
samps = squeeze(theta(1,:,burnin:end));
posterior=hist(samps(:),g);
bar(g,posterior/sum(posterior)/binwidth,'hist')
hold on
plot(g,betapdf(g,sum(data)+1,n-sum(data)+1),'r','linewidth',2)

saveas(gcf,'example_posterior.png')