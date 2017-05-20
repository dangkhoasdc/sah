function [ P ] = HammRadiusPrecision( trainZ, q, r, gnd, junk )
%HAMRADIUSPRECISION Summary of this function goes here
%   Detailed explanation goes here
nquery = size(q, 1);

P = 0;
for i = 1:nquery
    point = q(i, :);
    dist = sum(bsxfun(@xor,trainZ,point),2);
    inds = find(dist <= r + 0.00001);
    if isempty(inds)
        continue;
    end
    
    if iscell(gnd)
        c = intersect(inds,gnd{i});
    else
        c = intersect(inds,gnd(i,:));
    end
    
    if exist('junk', 'var') && ~isempty(junk)
        c = setdiff(c, junk{i});
    end
    retrievedGoodPairs = numel(c);
    P = P + retrievedGoodPairs / numel(inds);
end
P = P / nquery;
end

