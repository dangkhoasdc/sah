% Return the k nearest neighbors of a set of query vectors
%
% Usage: [ids,dis] = nn(v, q, k, distype)
%   v                the dataset to be searched (one vector per column)
%   q                the set of queries (one query per column)
%   k  (default:1)   the number of nearest neigbors we want
%   distype          distance type: 1=L1,
%                                   2=L2         -> Warning: return the square L2 distance
%                                   3=chi-square -> Warning: return the square Chi-square
%                                   4=signed chis-square
%                                   16=cosine    -> Warning: return the *smallest* cosine
%                                                   Use -query to obtain the largest
%                    available in Mex-version only
%
% Returned values
%   idx         the vector index of the nearest neighbors
%   dis         the corresponding *square* distances
%
% Both v and q contains vectors stored in columns, so transpose them if needed
function [idx, dis] = my_nn (X, Q, k, distype, slicesize)


if ~exist('k'), k = 1; end
if ~exist('distype'), distype = 2; end
if ~exist('slicesize'), slicesize = 1000; end
assert (size (X, 1) == size (Q, 1));

% Settings for distance
switch distype
  case {2,'L2'}, mode = 'ascend';
  case {16,'COS'}, mode = 'descend';
end



% Main loop
switch distype
case {2,'L2'}
  % Compute half square norm
  X_nr = sum (X.^2) / 2;
  Q_nr = sum (Q.^2) / 2;
  sim = bsxfun (@plus, Q_nr', bsxfun (@minus, X_nr, Q'*X));

case {16,'COS'}
  sim = Q' * X;

otherwise
   error ('Unknown distance type');
end


[dis, idx] = kmin_or_kmax (sim, k, mode);



% Post-processing for some metrics
switch distype
case {2,'L2'}
  dis = dis * 2;
end


%------------------------------------------------
% Choose min or max depending on mode
function [dis,idx] = kmin_or_kmax (sim, k, mode)

if k == 1
  if mode(1) == 'a'
    [dis,idx] = min (sim, [], 2);
    dis = dis';
    idx = idx';
  else
    [dis,idx] = max (sim, [], 2);
    dis = dis';
    idx = idx';
  end

else  % k>1
  [dis, idx] = sort (sim, 2, mode);
  dis = dis (:, 1:k)';
  idx = idx (:, 1:k)';
end
