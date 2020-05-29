function [Slopes,rngState,XX,beta] = perm(Ratings,Features,NumPerms,rngState)
%
% Ratings is an nx1 vector of the anxiety ratings for each of the n trials.
% Features is an nxd matrix of brain-data features.
% Feature(i,k) is the kth feature measured on the ith trial. For instance,
%  Feature(i,k) might be average power in gamma in channel 7.
%
% Slopes(1,k) is the linear regression slope of Y=Features(:,k) on X=Ratings.
% 
% For m = 2:NumPerms+1, Slopes(m,k) is the linear regression slope of 
% Y=Features(:,k) on X=permuted Ratings.
%
% The code will also work if Features is an n x d1 x d2 x ...x ds array, in
% which case Slopes will be NumPerms+1 x d1 x d2 x ... x ds.
%
% (Optional input and ouput arguments can be used to control the rng
% state.)

% set / remember the rng state
if nargin < 4 || isempty(rngState), rngState = rng; else, rngState = rng(rngState); end

% sizes
n = numel(Ratings);
Fsz = size(Features);
if Fsz(1) ~= n, error('sizes of Ratings and Features do not match'); end

% initialize memory for the slopes
Slopes = zeros([NumPerms+1,Fsz(2:end)]);

% ndx holds the permutation, the initial case is the original order
ndx = 1:n;

% precompute the X part of the MLE for linear regression
X = [ones(n,1),Ratings(:)];
XX = X.'*X\X.';

% loop over permutations
for k = 1:NumPerms+1
    
    % get the permuted Features (not permuted when k = 1)
    %   (note: it is equivalent to permute the order of the values or the
    %    order of the ratings ... permuting values is easier for regression)
    % compute the coefficients using MLE for linear regression
    
    beta = XX*Features(ndx,:);
    
    % get the slopes
    Slopes(k,:) = beta(2,:);
    
    % get the permutation for the next k
    ndx = randperm(n);
end
