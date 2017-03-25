function [ output_args ] = counter( leaf_index,total_index )
% 
for i = 1:total_index
   output_args(i)=sum(sum(leaf_index==i));
end

end

