  [ desc_tr,desc_te ] = getcaltech(   )
 


% Build visual vocabulary (codebook) for 'Bag-of-Words method'
desc_sel = single(vl_colsubset(cat(2,desc_tr{:}), 10e4)); % Randomly select 100k SIFT descriptors for clustering


opts= struct;
opts.depth= 8;
opts.numTrees= 200;
opts.numSplits= 10;
opts.verbose= true;
opts.classifierID= 3;


idx=0;
for numBins = 10:2:520 % for instance,
    idx=idx+1;
    clear freq
    [Centre, ~] = kmeans(desc_sel ,numBins );
    disp('Encoding Images...')
    % Vector Quantisation
    Centre= double(Centre);
    [m,n]=size(desc_tr);
    i=0;
    for class=1:m
        for sample= 1:n
            i=i+1;
            image=double(desc_tr{class,sample});
            freq(i,:)= [ Quantisation(image,Centre) class];
        end
    end
    
    freq(:,1:end-1) = freq(:,1:end-1)./repmat(sum(freq(:,1:end-1),2),1,numBins);
    data_train= freq;
    clear freq i
    % Quantisation
    % write your own codes here
    % ...
    %#############################################################################
    display(['Bin = ',num2str(numBins)]);
    i=0;
    for class=1:10
        for sample= 1:15
            i=i+1;
            image=double(desc_te{class,sample});
            freq(i,:)= [ Quantisation(image,Centre) class];
        end
    end
    
    freq(:,1:end-1) = freq(:,1:end-1)./repmat(sum(freq(:,1:end-1),2),1,numBins);
    data_query= freq;
    
    % weak learners to use. Can be an array for mix of weak learners too
    
    X =data_train(:,1:end-1);
    Y = data_train(:,end);
    
    m= forestTrain(X, Y, opts);
    
    yhatTrain = forestTest(m, data_query(:,1:end-1));
    
    cmatrix= confusionmat(Y,yhatTrain);
    result(idx).bins=numBins;
    result(idx).cr=get_classification_rate(cmatrix);
    result(idx).cmatrix=cmatrix;
    result(idx).pre=get_F1(cmatrix);
    result(idx).cmatrix=cmatrix;
    result(idx).opts=opts;
    stats(idx,1)=get_classification_rate(cmatrix);
    stats(idx,2)=numBins;
    
end
save('change_k.mat','result','stats')
clear result;
clear stats freq
numBin =150;
[Centre, ~] = kmeans(desc_sel ,numBin );
% Vector Quantisation
Centre= double(Centre);
[m,n]=size(desc_tr);
i=0;
freq=zeros(150,numBin+1);
for class=1:m
    for sample= 1:n
        i=i+1;
        image=double(desc_tr{class,sample});
        freq(i,:)= [ Quantisation(image,Centre) class];
    end
end

freq(:,1:end-1) = freq(:,1:end-1)./repmat(sum(freq(:,1:end-1),2),1,numBin);
data_train= freq;
clear freq i
% Quantisation
% write your own codes here
% ...
%#############################################################################
 
i=0;
freq=zeros(150,numBin+1);
for class=1:10
    for sample= 1:15
        i=i+1;
        image=double(desc_te{class,sample});
        freq(i,:)= [ Quantisation(image,Centre) class];
    end
end

freq(:,1:end-1) = freq(:,1:end-1)./repmat(sum(freq(:,1:end-1),2),1,numBin);
data_query= freq;

% weak learners to use. Can be an array for mix of weak learners too

X =data_train(:,1:end-1);
Y = data_train(:,end);
idx=0;
for numTrees = 2:2:500; % for instance,
    idx=idx+1;
    m= forestTrain(X, Y, opts);
    yhatTrain = forestTest(m, data_query(:,1:end-1));
    opts.numTrees=numTrees;
    cmatrix= confusionmat(Y,yhatTrain);
    result(idx).bins=numBins;
    result(idx).cr=get_classification_rate(cmatrix);
    result(idx).pre=get_F1(cmatrix);
    result(idx).cmatrix=cmatrix;
    result(idx).opts=opts;
    stats(idx,1)=get_classification_rate(cmatrix);
    stats(idx,2)=numTrees;
    display(['idx = ',num2str(idx)])
    
end
save('change_tree_no.mat','result','stats');
clear result;
clear stats;
files={'change_tree_no.mat','change_k.mat'};
upload('MLCV_CW_change_parameter','Here I changed some parameters',files)
