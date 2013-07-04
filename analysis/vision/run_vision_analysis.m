function [E X] = run_vision_analysis(W)

%% Compare to V1 simple cell data from:
%
% Van Hateren, J. H., & Van Der Schaaf, A. (1998). Independent
% component filters of natural images compared with simple cells in
% primary visual cortex. Proc. R. Soc. Lond. B, 265(1394),
% 359–66. doi:10.1098/rspb.1998.0303
%
%%%%%%%%%%%%%%%%%%%%%%

[E X] = vanHaterenComparison(W);