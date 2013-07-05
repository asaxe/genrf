function E = abc_examp_simul(thetas,particle_id,n,D)

rand('seed',particle_id(1))
X = sum(rand(n,size(thetas,2)) < repmat(thetas(1,:),n,1))/n;
E = D - X;
