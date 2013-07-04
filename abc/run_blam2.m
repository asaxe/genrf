function run_blam2(thetas, working_directory)

cwd = pwd;
expt_root = '~/dat_genrf/';
wd = strcat(expt_root,working_directory);

% make param file
[s,m,mid] = mkdir(wd);

pf = strcat(wd,'/params.txt')
fid = fopen(pf,'w');
for i = 1:size(thetas,2)
    fprintf(fid,'cd %s; /usr/local/bin/matlabr2012a -nodisplay -nojvm -nodesktop -nosplash -r "addpath(''~/genrf''),startup,run_ica(%s),exit"\n',wd,mat2str(thetas(:,i)));
     % confusing string escaping note: to get one single quote, put in two
end
fclose(fid);

% Run blam2

cd ~/blam2
tic
system(['./blam nodes_spec.txt ' pf]);
toc

cd(cwd)