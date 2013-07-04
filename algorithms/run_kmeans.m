function W = run_kmeans(theta,particle_id,rand_seed)
rand('seed',rand_seed)
randn('seed',rand_seed)

% Load data
[x, V] = load_vision_data(theta);

% Run k-means
[~, W] = kmeans(x', theta(3),'EmptyAction','singleton');

% Run analysis
W = W*V;

% Save results    

end