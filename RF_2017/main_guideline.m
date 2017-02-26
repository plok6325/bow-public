% Simple Random Forest Toolbox for Matlab
% written by Mang Shao and Tae-Kyun Kim, June 20, 2014.
% updated by Tae-Kyun Kim, Feb 09, 2017

% This is a guideline script of simple-RF toolbox.
% The codes are made for educational purposes only.
% Some parts are inspired by Karpathy's RF Toolbox

% Under BSD Licence

% Initialisation
init;

% Select dataset
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}


%%%%%%%%%%%%%
% check the training and testing data
    % data_train(:,1:2) : [num_data x dim] Training 2D vectors
    % data_train(:,3) : [num_data x 1] Labels of training data, {1,2,3}
    
plot_toydata(data_train);

    % data_test(:,1:2) : [num_data x dim] Testing 2D vectors, 2D points in the
    % uniform dense grid within the range of [-1.5, 1.5]
    % data_train(:,3) : N/A
    
scatter(data_test(:,1),data_test(:,2),'.b');


% Set the random forest parameters for instance, 
param.num = 10;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 3;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only

%%%%%%%%%%%%%%%%%%%%%%
% Train Random Forest

% Grow all trees
trees = growTrees(data_train,param);


%%%%%%%%%%%%%%%%%%%%%%
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
% experiment with Caltech101 dataset for image categorisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init;

% Select dataset
% we do bag-of-words technique to convert images to vectors (histogram of codewords)
% Set 'showImg' in getData.m to 0 to stop displaying training and testing images and their feature vectors
[data_train, data_test] = getData('Caltech');
close all;



% Set the random forest parameters ...

param.num = 200;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 20;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
param.splitmethod= 2;  % splitmethod == 1  axis align ; splitmethod ==2 ,linear 

% Train Random Forest ...
trees = growTrees(data_train,param);


% Evaluate/Test Random Forest ...
ground_truth = data_train(:,end);
res= testTrees_fast(data_test(:,1:end),trees);
res(res==0)=1;
for i =  1 :length (res(:,1))
p_rf = trees(1).prob(res(i,:),:);

p_rf_sum = sum(p_rf)/length(trees);
[~,loc]=max(p_rf_sum);
data_test(i,end)=loc;
end

% show accuracy and confusion matrix ...

cmatrix= confusionmat(data_test(:,end),ground_truth); 
get_classification_rate(cmatrix)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% random forest codebook for Caltech101 image categorisation
% .....

%% external library 
opts= struct;
opts.depth= 5;
opts.numTrees= 200;
opts.numSplits= 8;
opts.verbose= true;
opts.classifierID= 4; % weak learners to use. Can be an array for mix of weak learners too

X =data_train(:,1:end);
Y = data_train(:,end);

m= forestTrain(X, Y, opts);

yhatTrain = forestTest(m, data_test(:,1:end));


cmatrix= confusionmat(data_test(:,end),ground_truth); 
get_classification_rate(cmatrix)