clear;

% add dependencies
addpath(genpath('evaluation_tools'));
addpath(genpath('utils'));
addpath(genpath('join_pool_hash'));
addpath(genpath('relaxed_ba'));
addpath(genpath('itq'));
addpath(genpath('data'));


%% config
% run algorithm config
do_learn_pool_hash = true;
% `holidays` or `oxford5k`
dataset         = 'holidays';
code_length     = 32;
netmodel        = 'vgg16';
netlayer        = 'conv5';
datadir         = fullfile(pwd(), 'data');
workdir         = fullfile(pwd(), 'workdir');


%% params for learn_pool_hash
maxiter_all     = 3;
maxiter_hash    = 20;


load(fullfile(datadir, ['gnd_' dataset '.mat']));
% load datatrain 
switch dataset
    case {'oxford5k'}
        trainset = 'paris6k';
        database = 'oxford5k';
        query = 'oxfordq';
    case 'holidays'
        trainset = 'flickr10k';
        database = 'holidays';
        query = 'holidaysq';
    otherwise 
		error('could not recognize the dataset');    
end

% load learned params
param_file = fullfile(workdir, ['sah_' dataset '_c' num2str(code_length) ...
                        '.mat']);
load(param_file); 
% load groundtruth 
gnd_inds = {gnd(:).ok};
junk = {gnd(:).junk};

% load data
db_vecs = load(fullfile(datadir, [database '_' netlayer '_' netmodel '.mat']));
query_vecs = load(fullfile(datadir, [query '_' netlayer '_' netmodel '.mat']));

db_vecs = db_vecs.vecs;
query_vecs = query_vecs.qvecs;


% database vecs
Btrain = cnn_binarize(db_vecs, W1, W2, gamma, mu);
% query vecs
Btest = cnn_binarize(query_vecs, W1, W2, gamma, mu);
%       {-1, 1} --> {0, 1}
Btrain = Btrain';
Btest = Btest';
Btest(Btest < 0) = 0;
Btrain(Btrain < 0) = 0;

disp ('[--- Binarizing completed .... ---]');
disp ('[--- Evaluation .... ---]');        

%% evaluation
K_map = size(Btrain, 1);
map = KNNMap( Btrain, Btest, K_map, gnd_inds, junk); 
fprintf('Params: L=%d gamma=%f mu=%f\n', ...
        code_length, gamma, mu);
fprintf('MAP = %f\n',map);
disp('=======================================');