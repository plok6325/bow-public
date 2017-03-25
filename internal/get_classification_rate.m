function [ classification_rate ] = get_classification_rate( c_matrix )
% Input : confusion matrix % N*N matrix 
% return c_ rate
 
correct_classified = 0;
for i = 1:length(c_matrix(:,1))
    correct_classified =correct_classified+ c_matrix(i,i);
end
classification_rate = correct_classified /sum(c_matrix(:));
end

