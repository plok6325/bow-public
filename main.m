% prepare 
clear all 
close all 
addpath(genpath('./RF_2017/')); 
addpath(genpath('./Random-Forest-Matlab/'));
cd('./RF_2017/')
init; 
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}
plot_toydata(data_train);
scatter(data_test(:,1),data_test(:,2),'.b');
param.num = 100;         % Number of trees
param.depth = 9;        % trees depth
param.splitNum = 10;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only


%% Q1 bagging 
%Given the training data set, we first generate multiple data subsets by Bagging (Boostrap
%Aggregating). Show e.g. four data subsets, and discuss the results, and the way you did bagging
% e.g. the size of each data subset, whether it was with or without replacement.

figure 


for i  = 1:4
    subplot(2,2,i)
  [data_train_sub{i}] =  get_sub_set(data_train , 1) ;
plot_toydata(data_train_sub{i});
end
title ('visualisation of 4 subset')
 

%%  Now we take one of the data subsets generated above, and grow a tree by recursively splitting
% the data
param.num = 100;         % Number of trees
param.depth = 9;        % trees depth
param.splitNum = 10;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
trees = growTrees(data_train,param);

%% plot leaf node dist 
figure 
[r,c]=size(trees(1).prob);
for i =1 :4
subplot(2,2,i)
bar(trees(1).prob(randi(r),:))
end
%% test tree. 

test_point = [-.5 -.7; .4 .3; -.7 .4; .5 -.5];

for n=1:4
    leaves = testTrees([test_point(n,:) 0],trees);
    % average the class distributions of leaf nodes of all trees
    p_rf = trees(1).prob(leaves,:);
    
    p_rf_sum = sum(p_rf)/length(trees);
    [~,loc]=max(p_rf_sum);
    prediction(n) =loc;  
end

for i = 1:4 
    subplot(3,2,i)
bar(p_rf(i,:))
end
 subplot(3,2,5)
bar(p_rf_sum)


%% Test on the dense 2D grid data, and visualise the results ... 
 
res= testTrees_fast(data_test(:,1:2),trees);
res(res==0)=1;
for i =  1 :length (res)
p_rf = trees(1).prob(res(i,:),:);

p_rf_sum = sum(p_rf)/length(trees);
[~,loc]=max(p_rf_sum);
data_test(i,3)=loc;
end

%% visualise 2d
plot_toydata(data_train);

for class = 1:3 

    idx= find(data_test(:,3) ==class);
    if class ==1 
    scatter(data_test(idx,1),data_test(idx,2),'.r');
    hold on
    elseif class ==2 
    scatter(data_test(idx,1),data_test(idx,2),'.g');
   hold on 
    else
    scatter(data_test(idx,1),data_test(idx,2),'.b');
        hold on
    end
end
 



