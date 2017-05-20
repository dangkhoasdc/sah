function [ B ] = cnn_binarize( data, W1, W2, gamma, mu)
% Calculate GMP and binarize
% find PHI

num_samples = numel(data);
dim = size(data{1}, 3);
PHI = zeros(dim, num_samples);

for i = 1:num_samples
      x = data{i};
      x = reshape(x, 37 * 37, 512);
	  v = x';
	  ni = size(v,2);
	  % PHI(:,i) = (lambda*(W1'*W1) + gamma*(V{i}*V{i}') + (gamma*mu+1)*eye(D))\((W2*+lambda*W1')*B(:,i)+gamma*V{i}*ones(ni,1));
	  tmp = eye(dim) - W2*W1;
	  G = ((tmp'*tmp) + gamma*(v*v') + (gamma*mu)*eye(dim) ) ;
	  PHI(:,i) = G \ (gamma*v*ones(ni,1)); %A^-1*b = A\b 
      
end

B = sign(W1 * PHI);
end

