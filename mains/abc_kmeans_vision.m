
% Parameters governing abcde

N = 88;
T = inf;
burnin = 100;
freeze_mask = 4; % Indicates that parameter 2 should be frozen
                 % after the burnin period, since parameter 2 is delta
integer_mask = [1 2 3];

expt_dir = 'expt2';


% Necessary function pointers
psi = @(p,d) normpdf(p,0,d(end,:));
simul = @(p,pid,itr) run_generation(p,pid,itr,'run_kmeans');
prior = @kmeans_prior;
samp_prior = @kmeans_samp;

cwd = pwd;
expt_path = ['~/dat_genrf/vision/kmeans/' expt_dir];
mkdir(expt_path);
cd(expt_path);

save('abcde_params.mat', 'burnin','N','T','freeze_mask','integer_mask','psi','simul','prior','samp_prior')
abcde(psi,simul,prior,samp_prior, N, T, burnin, freeze_mask, integer_mask)

cd(cwd)

