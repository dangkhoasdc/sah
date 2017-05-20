

function R = KNNRecall(trainZ,testZ,K,gt)

	[numTest,b] = size(testZ); R = zeros(size(K));
	for i = 1:numTest
	  point = testZ(i,:);
	  dist = sum(bsxfun(@xor,trainZ,point),2);
	  [~,idx] = sort(dist);
	  for j = 1:numel(K)
		idx1 = idx(1:K(j));
        
        if iscell(gt)
            c = intersect(idx1,gt{i});
        else
            c = intersect(idx1,gt(i,:));
        end

		retrievedGoodPairs = numel(c);
		num_gnd = numel(gt{i});
		if num_gnd == 0
			continue;
		end
		R(j) = R(j) + retrievedGoodPairs/num_gnd;
	  end
	end
	R = R/numTest;

end

