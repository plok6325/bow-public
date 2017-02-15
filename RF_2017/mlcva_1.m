% MLCV cw

init;
[data_train, data_test] = getData('Toy_Spiral');

plot_toydata(data_train);
scatter(data_test(:,1),data_test(:,2),'.b');

