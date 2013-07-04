function [Z,E,D] = zca(X)

% do ZCA on image patches
%
% INPUT variables:
% X                  matrix with image patches as columns
%
% OUTPUT variables:
% Z                  half of whitening matrix
% E                  principal component transformation (orthogonal)
% D                  variances of the principal components
% 
% Andrew Saxe, 11/21/2010
% Based off of pca.m from the NIS package.

% Calculate the eigenvalues and eigenvectors of the new covariance matrix.
covarianceMatrix = X*X'/size(X,2);
[E, D] = eig(covarianceMatrix);

% Sort the eigenvalues  and recompute matrices
[dummy,order] = sort(diag(-D));
E = E(:,order);
d = diag(D); 
dquadrtinv = real(d.^(-0.25));
Dquadrtinv = diag(dquadrtinv(order));
D = diag(d(order));
Z = Dquadrtinv*E';



