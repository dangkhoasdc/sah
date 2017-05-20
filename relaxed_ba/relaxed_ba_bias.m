function [W2, W1, c1, c2, B] = relaxed_ba_bias (X, L, max_iter, lambda, beta)

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
% %% init B by PCA
% Xtmp = X';
% [pc, l] = eigs(cov(Xtmp),L);
% Xtmp = Xtmp * pc;
% B = sign(Xtmp);
%%
B = B';
%%
c1 = rand(L,1);
c2 = rand(D,1);
% c1 = ones(L,1);
% c2 = ones(D,1);
%%
for i = 1:max_iter
%% given B, compute W1
%W1 = (lambda*B*X')/(lambda*(X*X') + beta*eye(D)); % b*inv(A) = b/A;
W1 = lambda*((B+c1*ones(1,m))*X')/(lambda*(X*X') + beta*eye(D));

%% given B, compute W2
%W2 = (X*B')/(B*B' + beta*eye(L));
W2 = ((X-c2*ones(1,m))*B')/(B*B' + beta*eye(L));

%% compute c1
c1 = (1/m)*(B-W1*X)*ones(m,1);
%% compute c2
c2 = (1/m)*(X-W2*B)*ones(m,1);
%% 
%% given W1, W2, c1, c2, compute B
Xtmp = X - c2*ones(1,m);
H = W1*X + c1*ones(1,m);
[B] = learn_B_new(Xtmp', W2', B', H', lambda);

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

