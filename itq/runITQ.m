function [ Y, pc, R ] = runITQ( X, bit )
%RUNITQ run ITQ
%   X: mxD
%   bit: mxK
n = size(X,1);
% center the data, VERY IMPORTANT
sampleMean = mean(X,1);
X = (X - repmat(sampleMean,size(X,1),1));

 % PCA
[pc, l] = eigs(cov(X),bit);
X = X * pc;
% ITQ
[Y, R] = ITQ(X,50);
X = X*R;
Y = zeros(size(X));
Y = sign(X);


end

