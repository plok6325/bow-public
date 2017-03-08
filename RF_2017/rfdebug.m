[ desc_tr,desc_te ] = getcaltech(   )
opts= struct;
opts.depth= 8;
opts.numTrees= 200;
opts.numSplits= 10;
opts.verbose= true;
opts.classifierID= 3;

%% 
disp('Building visual codebook...')
% Build visual vocabulary (codebook) for 'Bag-of-Words method'
desc_tr1= [] ;
for  i = 1:10
    for r =1:15
        [m,n] = size(desc_tr{i,r});
        temp= [desc_tr{i,r} ; repmat(i,1,n)];
        desc_tr1= [ desc_tr1 temp];
        
    end
end
desc_sel = single(vl_colsubset(desc_tr1 , 10e4)); % Randomly select 100k SIFT descriptors for clustering

%  RF 
%################################################################


desc_sel =desc_sel';
X=desc_sel(:,1:end-1);
Y = desc_sel(:,end);


param.num = 15;         % Number of trees
idx=0;
for num = 2:1:30
    idx=idx+1;
    param.num = num;
    param.depth = 8;        % trees depth
    param.splitNum = 20;     % Number of split functions to try
    param.split = 'IG';     % Currently support 'information gain' only
    param.splitmethod= 2;
    rf= growTrees(desc_sel,param);
    total_index=length(rf(1).prob(:,1));
    disp(['Encoding Images... num = ',num2str(num)])
    % Vector Quantisation
    
    [m,n]=size(desc_tr);
    i=0;
    for class=1:m
        for sample= 1:n
            i=i+1;
            image=double(desc_tr{class,sample});
            leaf_index=testTrees_fast(image',rf);
            freq(i,:)= [counter(leaf_index, total_index) class];
        end
    end
    
    data_train= freq;
    clear freq
    %################################################################
    % Clear unused varibles to save memory
    
    
    % Quantisation
    % write your own codes here
    % ...
    %#############################################################################
    i=0;
    for class=1:10
        for sample= 1:15
            i=i+1;
            image=double(desc_te{class,sample});
            leaf_index=testTrees_fast(image',rf);
            freq(i,:)= [counter(leaf_index, total_index) 0];
        end
    end
    
    data_test= freq;
    clear freq 
    %##############################################################################
    
    X =data_train(:,1:end-1);
    Y = data_train(:,end);
    trees = forestTrain(X,Y,opts);
    yhatTrain = forestTest(trees, data_test(:,1:end-1));
    
    cmatrix= confusionmat(Y,yhatTrain);
    result(idx).depth=num;
    result(idx).cr=get_classification_rate(cmatrix);
    result(idx).cmatrix=cmatrix;
    result(idx).pre=get_F1(cmatrix);
    result(idx).cmatrix=cmatrix;
    result(idx).opts=opts;
    stats(idx,1)=get_classification_rate(cmatrix);
    stats(idx,2)=num;

end
save('rf_change_num.mat','result','stats')
