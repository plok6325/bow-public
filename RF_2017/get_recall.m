function [ recall ] = get_recall( c_matrix )
%CALCULATE recall for each class 
for i = 1: length(c_matrix(:,1))
    recall(i) =  c_matrix(i,i) / sum(c_matrix(i,:)) ;
end
end

