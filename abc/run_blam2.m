function run_blam2(thetas, particle_id, fn_str)

% make param file

wd = pwd;
pf = 'params.txt';
fid = fopen(pf,'w');
for i = 1:size(thetas,2)
    fprintf(fid,'cd %s; matlab -nodisplay -nojvm -nodesktop -nosplash -r "addpath(''~/genrf''),startup,%s(%s,%d),exit"\n',wd,fn_str,mat2str(thetas(:,i)),particle_id(i));
     % confusing string escaping note: to get one single quote, put in two
end
fclose(fid);

% Run blam2

tic
system(['blam2 ~/blam2/nodes_spec.txt ' pf]);
toc

