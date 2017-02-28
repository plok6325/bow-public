function [ F1 ] = get_F1( c_matrix )
%Return F1 score
recall=get_recall(c_matrix);
precision=get_precision(c_matrix);
F1 = 2*recall.*precision ./(precision+recall);

end

