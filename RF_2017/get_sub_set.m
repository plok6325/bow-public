function [ sub_data ] = get_sub_set( data ,r )
% from data set. select equal number of instances . with replacement 
[m,n]= size (data);

 idx = randsample(m,m,r);
sub_data = data(idx,:);
 
end
