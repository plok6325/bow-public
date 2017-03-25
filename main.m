clear all 
close all 
addpath(genpath('./Random-Forest-Matlab/'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% experiment with Caltech101 dataset for image categorisation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

init;

[data_train, data_test] = getData('Caltech');
 
% external library 

opts= struct;
opts.depth= 5;
opts.numTrees= 100;
opts.numSplits= 50;
opts.verbose= true;
opts.classifierID= 2; % weak learners to use. Can be an array for mix of weak learners too
X =data_train(:,1:end-1);
Y =data_train(:,end);

m= forestTrain(X, Y, opts);

yhatTrain = forestTest(m, data_test(:,1:end-1));


cmatrix= confusionmat(Y,yhatTrain); 
get_classification_rate(cmatrix)
