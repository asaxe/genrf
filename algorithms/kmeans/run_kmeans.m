function W = run_kmeans(theta,particle_id)
rand('seed',particle_id)
randn('seed',particle_id)

% Load data
[x, V] = load_vision_data(theta);

% Run k-means

[~, W] = kmeans(x', int32(theta(3)),'EmptyAction','singleton');

% Run analysis
W = W*V;

[E X] = run_vision_analysis(W);

% Save results    
save(sprintf('res%d.mat',particle_id),'E','X','theta','particle_id');

end