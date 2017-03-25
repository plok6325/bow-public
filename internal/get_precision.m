function [ precision ] = get_precision( c_matrix )
%CALCULATE precision for each class

for i = 1: length(c_matrix(:,1))
     
    precision(i) = c_matrix(i,i) / sum(c_matrix(:,i));
end


end

