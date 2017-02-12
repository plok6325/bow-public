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
% Train Random Forest ...
% Evaluate/Test Random Forest ...
% show accuracy and confusion matrix ...


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% random forest codebook for Caltech101 image categorisation
% .....



