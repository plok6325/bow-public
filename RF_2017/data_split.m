function [ data_subset ] = data_split( data, k  )
% partition  data in to k parts 
[m,n]= size (data);
Indices = crossvalind('Kfold', m, k) ; 
for i= 1 : k
    
data_subset{i} = data (find(Indices==i),:);


end
end
