function [ freq ] = Quantisation( image, centroids )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
 

 distance = pdist2(image',centroids');
 
 
[M i]= min(distance,[],2);
freq= zeros(1,length(centroids(:,1)));
for x = 1:length(centroids(1,:))
    freq(x)=length(find(i==x));
end


end

