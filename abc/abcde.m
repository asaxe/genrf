function abcde(psi,simul,prior,samp_prior,N,T,burnin,freeze_mask,integer_mask)  
% ABCDE implementation by Andrew Saxe (asaxe@stanford.edu)
% after:
%
% Turner, B. M., & Sederberg, P. B. (2012). Approximate Bayesian
% computation with differential evolution. Journal of Mathematical
% Psychology, 56(5), 375–385. doi:10.1016/j.jmp.2012.06.004
%
% w=psi(Es,thetas): function to evaluate particle fitness, accepting
% E, a vector of the error measure produced by the simulator for
% each particle, and thetas, a matrix with parameter vectors in the
% columns, which can contain delta to estimate the error
% variance
%
% E=simul(thetas): function that runs the simulation of all particles
% for one iteration. Accepts a matrix thetas containing the theta
% vectors for each particle in the columns. Returns E, the error
% measure produced for each particle, which in the notation of the
% paper should be E = D - X. This implementation has not been tested with
% E as a matrix, with each column containing a vector, i.e., it may
% need modification if each particle does not just produce one scalar.
%
% p=prior(thetas): function that gives probability of parameter
% vectors under the prior. Thetas contains parameter vectors, one
% per column. The returned value p should be a row vector of
% probabilities.
% 
% S=samp_prior(N): function that samples N parameter vectors from the
% prior probability distribution defined by prior(...). Must return
% the M x N matrix S which has sampled vectors in the columns,
% where M is the length of the parameter vector.
%
% N: number of particles per iteration
%
% T: number of iterations (may be inf)   
%
% burnin: number of iterations used for the 'burn in' period, in
% which the parameters of the error function psi are allowed to
% vary, and the evolution process uses a hill climbing term that
% rapidly finds high probability regions of the posterior but
% would bias the posterior if used during the sampling period.
%
% freeze_mask: a vector of indices that specify elements of the
% parameter vector that should be frozen during the sampling period
%

% Parameter governing small amount of random noise added during
% crossover step
epsilon = .001;

% Initialize
t=1;
theta = samp_prior(N);
particle_id = 1:N;
E = simul(theta,particle_id,t);
w = prior(theta).*psi(E,theta);
accepted = ones(size(w));
save(sprintf('itr%d.mat',t),'t','theta','E','w','particle_id','accepted');

M = size(theta,1);


while t < T 
    t=t+1
    % Generate proposals theta_star
    theta_star = zeros(size(theta));
    particle_id = N*(t-1)+1:N*t;
    for i = 1:N
        
        % Crossover update
        theta_t = theta(:,i);
        
        theta_b = theta(:,randsample(1:N,1,true,w));
        tmp = theta(:,randsample(setdiff(1:N,i),2,false));
        theta_m = tmp(:,1);
        theta_n = tmp(:,2);
        
        gamma_1 = unifrnd(0.5,1);
        gamma_2 = unifrnd(0.5,1);
        b = unifrnd(-epsilon,epsilon,M,1);
                
        if t > burnin
            gamma_2 = 0;
        end

        theta_star(:,i) = theta_t + gamma_1*(theta_m - theta_n) + ...
            gamma_2*(theta_b - theta_t) + b;

        if t > burnin
            theta_star(freeze_mask,i) = theta_t(freeze_mask); % always reset frozen parameters
                                                              % during sampling
        end

        theta_star(integer_mask,:) = round(theta_star(integer_mask,:));
    end
       
       
        
    % Run simulations
    pr_star = prior(theta_star);

    E_star = simul(theta_star(:,pr_star > 0),particle_id(pr_star > 0),t);
    % if prior is not > 0, parameters may not make sense. No need to simulate.
                                                 
    % Jump to proposal with metropolis hastings probability r
    r = zeros(1,N);
    r(pr_star>0) = min(1, (psi(E_star,theta_star(:,pr_star > 0)).*pr_star(pr_star>0)) ./ (psi(E(pr_star>0),theta(:,pr_star>0)).*prior(theta(:,pr_star>0)) ));
    r
    accepted = rand(1,N) < r;
    theta(:,accepted) = theta_star(:,accepted);
    
    E(accepted) = E_star(accepted(pr_star > 0));

    if t == burnin
        theta(freeze_mask,:) = median(theta(freeze_mask,:));
    end
            
    w = prior(theta) .* psi(E,theta);
    w = w/sum(w);
    
    % Save iteration results
    save(sprintf('itr%d.mat',t),'t','theta','E','w','particle_id','accepted');
end

