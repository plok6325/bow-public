function [ centre ] = init_cluster_centre( data,k )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
[R C]= size(data);
r_cent= randi(C,1,k);
centre = data(:,r_cent)
end

