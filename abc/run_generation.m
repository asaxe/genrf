function E = run_generation(thetas,particle_id,itr,fn_str)


cwd = pwd;
wd = sprintf('itr%d',itr);
mkdir(wd)
cd(wd)

run_blam2(thetas, particle_id, fn_str)

% Load in returned values
ind = 1;
for p = particle_id
    tmp = load(sprintf('res%d',p),'E');
    E(ind) = tmp.E;
    ind = ind+1;
end

cd(cwd)



