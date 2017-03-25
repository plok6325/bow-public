function [node,nodeL,nodeR] = splitNode(data,node,param)
% Split node

visualise = 0;

% Initilise child nodes
iter = param.splitNum;  % number of attempt
nodeL = struct('idx',[],'t',nan,'dim',0,'prob',[]);
nodeR = struct('idx',[],'t',nan,'dim',0,'prob',[]);

if length(node.idx) <= 5 % make this node a leaf if has less than 5 data points
    node.t = nan;
    node.dim = 0;
    return;
end

idx = node.idx;
data = data(idx,:);
[N,D] = size(data);
ig_best = -inf; % Initialise best information gain
idx_best = [];
for n = 1:iter
    
    % Split function - Modify here and try other types of split function
    
    if param.splitmethod == 1
        dim = randi(D-1); % Pick one random dimension
        d_min = single(min(data(:,dim))) + eps; % Find the data range of this dimension
        d_max = single(max(data(:,dim))) - eps;
        t = d_min + rand*((d_max-d_min)); % Pick a random value within the range as threshold
        idx_ = data(:,dim) < t;
        ig = getIG(data,idx_); % Calculate information gain
        
        if visualise
            visualise_splitfunc(idx_,data,dim,t,ig,n);
            pause();
        end
        
        [node, ig_best, idx_best] = updateIG(node,ig_best,ig,t,idx_,dim,idx_best);
    else    % splitmethod == linear
        
        r1= randi(D-1);
        r2= randi(D-1);
        
        w= randn(3, 1);
        
        idx_ = [data(:, [r1 r2]), ones(N, 1)]*w < 0;
        
         ig = getIG(data,idx_); % Calculate information gain
        
        [node, ig_best, idx_best] = updateIG(node,ig_best,ig, w,idx_,[r1 r2],idx_best);
        
    end
    
end

nodeL.idx = idx(idx_best);
nodeR.idx = idx(~idx_best);

if visualise
    visualise_splitfunc(idx_best,data,dim,t,ig_best,0)
    fprintf('Information gain = %f. \n',ig_best);
    pause();
end

end

