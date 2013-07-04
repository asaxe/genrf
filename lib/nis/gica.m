%Simple code for ICA of images (using jacket)
%Original by Aapo Hyvärinen, for the book Natural Image Statistics

%Modified version that uses the jacket function to enable GPU
%processing, giving a 6-7x speedup

function W=gica(Z,n, num_iters)

global convergencecriterion

%------------------------------------------------------------
% input parameters settings
%------------------------------------------------------------
%
% Z                     : whitened image patch data
%
% n = 1..windowsize^2-1 : number of independent components to be estimated


% Some starter parameters
if (nargin < 3)
    num_iters = 2000; %default set in the book
end

%------------------------------------------------------------
% Initialize algorithm
%------------------------------------------------------------

Z_ = gsingle( Z );

%create random initial value of W, and orthogonalize it
W = orthogonalizerows(randn(n,size(Z,1))); 
W_= gsingle( W );

%read sample size from data matrix
N=gsingle( size(Z,2) );

%------------------------------------------------------------
% Start algorithm
%------------------------------------------------------------

writeline('Doing FastICA. Iteration count: ')

iter = gsingle(0);
notconverged = gsingle(1);

%iter = 0;
%notconverged = 1;

while notconverged & (iter<num_iters) %maximum of 2000 iterations

  iter=iter+1;
  
  %print iteration count
  writenum(iter);
  
  % Store old value
  Wold_ = W_;        

  %-------------------------------------------------------------
  % FastICA step
  %-------------------------------------------------------------  

    % Compute estimates of independent components 
    Y_ = W_*Z_; 
 
    % Use tanh non-linearity
    isreal(Y_)
    gY_ = tanh(Y_);
    
    % This is the fixed-point step. 
    % Note that 1-(tanh y)^2 is the derivative of the function tanh y
    W_ = gY_*Z_'/N - (mean(1-gY_'.^2)'*gones(1,size(W_,2))).*W_;    
    
    % Orthogonalize rows or decorrelate estimated components
    W_ = gsingle(orthogonalizerows(double(W_)));

  % Check if converged by comparing change in matrix with small number
  % which is scaled with the dimensions of the data
  if norm(abs(W_*Wold_')-geye(n),'fro') < convergencecriterion * n; 
        notconverged=0; end

end %of fixed-point iterations loop
W = double( W_ );







