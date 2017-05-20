function [ W2, W1, B, PHI ] = cnn_learn_pool_hash(L, lambda, beta_reg, ...
    gamma, mu, maxiter_hash, maxiter_all, traindata )
%% minimize the loss:
% (1/2)||PHI-W2B||^2 + (lambda/2)||B-W1PHI||^2 + (beta/2)(||W1||^2 + ||W2||^2)+ ...
%                    (gamma/2)sum_i=1^n (||Vi'PHIi-1||^2 + mu||PHIi||^2)   
%% input: 
% traindata: local descriptors. traindata{i}: local descriptors for image i
% L: code length
% lambda, beta, gamma, mu: penalty param
% maxiter_hash: number of iterations using in side hashing step
% maxiter_all: number of iterations for iterative learning of pool and hash
%% output: decoder W2, encoder W1, binary code matrix B, pooled matrix PHI
%number of images
%D = size(V{1},1); %dimension of local decscriptor

m = numel(traindata);

D = size(traindata{1}, 3); % dimension of local descriptor
%% init PHI by generalized max pooling
% run in batch mode
% compute PHI
PHI = zeros(D,m);
for i = 1:m
    x = traindata{i};
    x = reshape(x, 37 * 37, 512); % conv5 - VGG16;
    v = single(x');
    ni = size(v,2); % V{i} = [D,ni];
    PHI(:, i) = (v*v' + mu*eye(D))\(v*ones(ni,1));%inv(V{i}*V{i}' + mu*eye(D))*(V{i}*ones(ni,1));
    PHI(:, i) = yael_vecs_normalize(PHI(:, i), 2, 0);
end


%% alternative learn (W2, W1, B) and PHI
for t = 1:maxiter_all
    %hashing step: fix PHI, learn (W2, W1, B)
    [W2, W1, B] = relaxed_ba (PHI, L, maxiter_hash, lambda, beta_reg);
    %pooling step: fix (W2, W1, B), learn PHI
    % clear the old PHI
    PHI(:, :) = 0;
     
    for i = 1:m
        x = traindata{i};
        x = reshape(x, 37 * 37, 512); % conv5 - VGG16;
        v = single(x');
        % PHI(:,i) = (lambda*(W1'*W1) + gamma*(V{i}*V{i}') + (gamma*mu+1)*eye(D))\((W2*+lambda*W1')*B(:,i)+gamma*V{i}*ones(ni,1));
        ni = size(v,2); 
        tmp = eye(D) - W2*W1;
        G = ((tmp'*tmp) + gamma*(v*v') + (gamma*mu)*eye(D));
        PHI(:,i) = G \ (gamma*v*ones(ni,1)); %A^-1*b = A\b;
        PHI(:, i) = yael_vecs_normalize(PHI(:, i), 2, 0);
    end

end

B = sign(W1 * PHI);


