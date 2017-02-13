clear all 
close all 
oldpath  = addpath(genpath('./RF_2017/'),'-frozen'); 

init; 
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}
 
plot_toydata(data_train);


scatter(data_test(:,1),data_test(:,2),'.b');

param.num = 10;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 3;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only


%% Q1 bagging 
%Given the training data set, we first generate multiple data subsets by Bagging (Boostrap
%Aggregating). Show e.g. four data subsets, and discuss the results, and the way you did bagging
% e.g. the size of each data subset, whether it was with or without replacement.

[data_train_sub] =  data_split(data_train , 4) ;

for i  = 1:4
    subplot(2,2,i)
plot_toydata(data_train_sub{i});
end
title ('visualisation of 4 subset (training )')

%  Now we take one of the data subsets generated above, and grow a tree by recursively splitting
% the data
param.num = 10;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 3;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
trees = growTrees(data_train_sub{1},param);



