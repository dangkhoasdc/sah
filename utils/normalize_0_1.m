function [ norm_train, norm_query, norm_base ] = normalize_0_1( data_train, data_query, data_base )
%NORMALIZE_0_1 normalizes data to [0:1]
max_dims = max(data_train,[],1); min_dims = min(data_train,[],1); 
range_dims = max(max(max_dims-min_dims+eps));
norm_train = bsxfun(@minus,data_train,min_dims); norm_train = bsxfun(@rdivide,norm_train,range_dims);

norm_query = bsxfun(@minus, data_query, min_dims);
norm_query = bsxfun(@rdivide, norm_query, range_dims);

if exist('data_base', 'var')
    norm_base = bsxfun(@minus, data_base, min_dims);
    norm_base = bsxfun(@rdivide, norm_base, range_dims);
else
    norm_base = [];
end
end

