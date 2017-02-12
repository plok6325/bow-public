function label = testTrees(data,tree)
% Slow version - pass data point one-by-one

cc = [];
for T = 1:length(tree)
    for m = 1:size(data,1);
        idx = 1;
        
        while tree(T).node(idx).dim
            t = tree(T).node(idx).t;
            dim = tree(T).node(idx).dim;
            % Decision
            if data(m,dim) < t % Pass data to left node
                idx = idx*2;
            else
                idx = idx*2+1; % and to right
            end
            
        end
        leaf_idx = tree(T).node(idx).leaf_idx;
        
        if ~isempty(tree(T).leaf(leaf_idx))
            p(m,:,T) = tree(T).leaf(leaf_idx).prob;
            label(m,T) = tree(T).leaf(leaf_idx).label;
            
%             if isfield(tree(T).leaf(leaf_idx),'cc') % for clustering forest
%                 cc(m,:,T) = tree(T).leaf(leaf_idx).cc;
%             end
        end
    end
end

end

