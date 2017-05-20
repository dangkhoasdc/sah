function [W2, W1, B] = relaxed_ba ( X, L, max_iter, lambda, beta)
%%  minimize function: (1/2)||X-W2B||^2 + (lambda/2)||B-W1X||^2 + (beta/2)(||W1||^2 + ||W2||^2)

%% input: 
%X: training samples. X = [D,m] where D is dimension of samples, m is number of samples
%L: code length
%max_iter: number of iteration for alternative learning (W2, W1) and B
% lambda, beta: penalty params
%% output: decoder W2, encoder W1, binary code matrix B

[D,m] = size(X);
%% init B by ITQ
[B, pc, R] = runITQ(X', L);
%% init by ITQ
% Xtmp = X;
% [pc, l] = eigs(cov(Xtmp'),L);
% Xtmp = Xtmp * pc;
% [Y, R] = ITQ(Xtmp,50);
% Xtmp = Xtmp*R;
% B = sign(Xtmp);
B = B';

%%
for i = 1:max_iter
%% given B, compute W1
W1 = (lambda*B*X')/(lambda*(X*X') + beta*eye(D)); % b*inv(A) = b/A;
%% given B, compute W2
W2 = (X*B')/(B*B' + beta*eye(L));
%% given W1, W2, compute B
H = W1*X;
[B] = learn_B_new(X', W2', B', H', lambda);
B = B';
end

function Bout = learn_B_new(Y, Wg, Bpre, XF, nu)

% Y: m * c
% Wg = L * c
% XF: m * L
% Bpre: m * L

B = Bpre;
% B = zeros(size(Bpre));
% B = sign(XF);

Q = nu * XF + Y*Wg'; 
L = size(B,2);

for time = 1:10
    Z0 = B;
    for k = 1:L %closed form for each row of B
        Zk = B;
        Zk(:,k) = []; %ignore bit k
        Wkk = Wg(k,:);
        Wk = Wg;
        Wk(k,:) = [];
        B(:,k) = sign( Q(:,k) - Zk*Wk*Wkk' );
    end
%     if norm(B-Z0,'fro') < 1e-10 * norm (Z0,'fro')
%         break;
%     end
end

Bout = B;

