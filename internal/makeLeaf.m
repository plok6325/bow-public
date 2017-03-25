% Leaf Nodes
cnt = 1;
cnt_total = 1;
for n = 1:2^param.depth-1
    if ~isempty(trees(T).node(n).idx)
        % Percentage of observations of each class label
        trees(T).node(n).prob = single(histc(data_train(trees(T).node(n).idx,end),labels))/single(length(trees(T).node(n).idx));
        
        if ~trees(T).node(n).dim
            trees(T).node(n).leaf_idx = cnt;
            trees(T).leaf(cnt).label = cnt_total;
            prob = reshape(histc(data_train(trees(T).node(n).idx,end),labels),[],1);
            
            trees(T).leaf(cnt).prob = prob; %.*prior; % Multiply by the prior probability of bootstrapped sub-training-set
            trees(T).leaf(cnt).prob = trees(T).leaf(cnt).prob./sum(trees(T).leaf(cnt).prob); % Normalisation
            
            trees(1).prob(cnt_total,:) = trees(T).node(n).prob';
            
            cnt = cnt+1;
            cnt_total = cnt_total + 1;
        end
    end
end