clear all 
close all 
addpath(genpath('./Random-Forest-Matlab/'));
init;
%%  Select dataset
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}
 
plot_toydata(data_train);
scatter(data_test(:,1),data_test(:,2),'.b');

%% bagging  


for i  = 1:4
    subplot(2,2,i)
  [data_train_sub{i}] =  get_sub_set(data_train , 1) ;
plot_toydata(data_train_sub{i});
end
title ('visualisation of 4 subset')
 
%%   Train Random Forest
param.num = 10;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 3;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
% Grow all trees
trees = growTrees(data_train,param);

%% plot leaf node dist 
figure 
[r,c]=size(trees(1).prob);
for i =1 :4
subplot(2,2,i)
bar(trees(1).prob(randi(r),:))
end
%%
% Evaluate/Test Random Forest

% grab the few data points and evaluate them one by one by the leant RF
test_point = [-.5 -.7; .4 .3; -.7 .4; .5 -.5];
for n=1:4
    leaves = testTrees([test_point(n,:) 0],trees);
    % average the class distributions of leaf nodes of all trees
    p_rf = trees(1).prob(leaves,:);
    p_rf_sum = sum(p_rf)/length(trees);
end


% Test on the dense 2D grid data, and visualise the results ... 

param.num = 100;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 20;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
param.splitmethod= 2;  % splitmethod == 1  axis align ; splitmethod ==2 ,linear 
trees = growTrees(data_train,param);

res= testTrees_fast(data_test(:,1:2),trees);
res(res==0)=1;
for i =  1 :length (res)
p_rf = trees(1).prob(res(i,:),:);
p_rf_sum = sum(p_rf)/length(trees);
[~,loc]=max(p_rf_sum);
data_test(i,end)=loc;
end


%visualise 2d
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
 


% Change the RF parameter values and evaluate ... 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% experiment with Caltech101 dataset for image categorisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init;

% Select dataset
% we do bag-of-words technique to convert images to vectors (histogram of codewords)
% Set 'showImg' in getData.m to 0 to stop displaying training and testing images and their feature vectors

[data_train, data_test] = getData('Caltech');
 
% external library 

opts= struct;
opts.depth= 5;
opts.numTrees= 300;
opts.numSplits= 20;
opts.verbose= true;
opts.classifierID= 3; % weak learners to use. Can be an array for mix of weak learners too
X =data_train(:,1:end-1);
Y =data_train(:,end);

m= forestTrain(X, Y, opts);

yhatTrain = forestTest(m, data_test(:,1:end-1));


cmatrix= confusionmat(Y,yhatTrain); 
get_classification_rate(cmatrix)

%% RF as codebook 



[data_train, data_test] = getData_rf();


opts= struct;
opts.depth= 5;
opts.numTrees= 300;
opts.numSplits= 20;
opts.verbose= true;
opts.classifierID= 3; % weak learners to use. Can be an array for mix of weak learners too
X =data_train(:,1:end-1);
Y =data_train(:,end);

m= forestTrain(X, Y, opts);

yhatTrain = forestTest(m, data_test(:,1:end-1));


cmatrix= confusionmat(Y,yhatTrain); 
get_classification_rate(cmatrix)
