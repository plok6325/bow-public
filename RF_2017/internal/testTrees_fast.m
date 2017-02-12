function label = testTrees_fast(data,tree)
% Faster version - pass all data at same time
disp('Testing Random Forest...');

cnt = 1;
for T = 1:length(tree)
    idx{1} = 1:size(data,1);
    for n = 1:length(tree(T).node);
        if ~tree(T).node(n).dim
            leaf_idx = tree(T).node(n).leaf_idx;
            if ~isempty(tree(T).leaf(leaf_idx))
                label(idx{n}',T) = tree(T).leaf(leaf_idx).label;
            end
            continue;
        end
        idx_left = data(idx{n},tree(T).node(n).dim) < tree(T).node(n).t;
        idx{n*2} = idx{n}(idx_left');
        idx{n*2+1} = idx{n}(~idx_left');
    end
end

end

