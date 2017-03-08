function [ data_train, data_query ] = getData_rf(   )

showImg = 0; % Show training & testing images and their image feature vector (histogram representation)

PHOW_Sizes = [4 8 10]; % Multi-resolution, these values determine the scale of each layer.
PHOW_Step = 8; % The lower the denser. Select from {2,4,8,16}

close all;

showImg = 0; % Show training & testing images and their image feature vector (histogram representation)

PHOW_Sizes = [4 8 10]; % Multi-resolution, these values determine the scale of each layer.
PHOW_Step = 8; % The lower the denser. Select from {2,4,8,16}
imgSel = [15 15]; % randomly select 15 images each class without replacement. (For both training & testing)
folderName = './Caltech_101/101_ObjectCategories';
classList = dir(folderName);
classList = {classList(3:end).name} % 10 classes

disp('Loading training images...')
% Load Images -> Description (Dense SIFT)
cnt = 1;
if showImg
    figure('Units','normalized','Position',[.05 .1 .4 .9]);
    suptitle('Training image samples');
end
for c = 1:length(classList)
    subFolderName = fullfile(folderName,classList{c});
    imgList = dir(fullfile(subFolderName,'*.jpg'));
    imgIdx{c} = randperm(length(imgList));
    imgIdx_tr = imgIdx{c}(1:imgSel(1));
    imgIdx_te = imgIdx{c}(imgSel(1)+1:sum(imgSel));
    
    for i = 1:length(imgIdx_tr)
        I = imread(fullfile(subFolderName,imgList(imgIdx_tr(i)).name));
        
        % Visualise
        if i < 6 & showImg
            subaxis(length(classList),5,cnt,'SpacingVert',0,'MR',0);
            imshow(I);
            cnt = cnt+1;
            drawnow;
        end
        
        if size(I,3) == 3
            I = rgb2gray(I); % PHOW work on gray scale image
        end
        
        % For details of image description, see http://www.vlfeat.org/matlab/vl_phow.html
        [~, desc_tr{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step); %  extracts PHOW features (multi-scaled Dense SIFT)
        %                 I = rot90(I);
        %                 [~, desc_tr2{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step); %  extracts PHOW features (multi-scaled Dense SIFT)
        %                 I = rot90(I);
        %                  [~, desc_tr3{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step); %  extracts PHOW features (multi-scaled Dense SIFT)
        %
    end
end

%         desc_tr= [desc_tr desc_tr2 desc_tr3];
%

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

% K-means clustering
%################################################################


desc_sel =desc_sel';

X=desc_sel(:,1:end-1);

Y = desc_sel(:,end);

 
param.num = 15;         % Number of trees
param.depth = 5;        % trees depth
param.splitNum = 20;     % Number of split functions to try
param.split = 'IG';     % Currently support 'information gain' only
param.splitmethod= 2; 
 

rf= growTrees(desc_sel,param);
total_index=length(rf(1).prob(:,1));
disp('Encoding Images...')
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
%################################################################
% Clear unused varibles to save memory
clearvars desc_tr desc_sel freq
 
disp('Processing testing images...');
cnt = 1;
% Load Images -> Description (Dense SIFT)
for c = 1:length(classList)
    subFolderName = fullfile(folderName,classList{c});
    imgList = dir(fullfile(subFolderName,'*.jpg'));
    imgIdx_te = imgIdx{c}(imgSel(1)+1:sum(imgSel));
    
    for i = 1:length(imgIdx_te)
        I = imread(fullfile(subFolderName,imgList(imgIdx_te(i)).name));
        
        % Visualise
        if i < 6 & showImg
            subaxis(length(classList),5,cnt,'SpacingVert',0,'MR',0);
            imshow(I);
            cnt = cnt+1;
            drawnow;
        end
        
        if size(I,3) == 3
            I = rgb2gray(I);
        end  
        
        [~, desc_te{c,i}] = vl_phow(single(I),'Sizes',PHOW_Sizes,'Step',PHOW_Step);
        
    end
end 
 
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

%##############################################################################

end

