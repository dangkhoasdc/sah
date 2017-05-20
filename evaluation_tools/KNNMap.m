function [ map ] = KNNMap( trainZ, testZ, K, gt, junk)

clear gnd;
[numTest,b] = size(testZ); 
map = zeros(length(K), 1);
for i = 1:length(K)
    k = K(i);
    ranks = zeros(k, numTest);
    % gnd = zeros(numTest, 1);
    
    for j = 1:numTest
        point = testZ(j,:);
        dist = sum(bsxfun(@xor,trainZ,point),2);
        [~,idx] = sort(dist);
        ranks(:,j) = idx(1:k);
        
        if iscell(gt)
            gnd(j).ok = gt{j};
            if exist('junk', 'var') && ~isempty(junk)
                gnd(j).junk = junk{j};
            end
        else 
            gnd(j).ok = gt(j,:)';
        end      
    end
    map(i) = compute_map(ranks, gnd);
end
end


