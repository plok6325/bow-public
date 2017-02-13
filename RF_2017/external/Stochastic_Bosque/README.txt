Simple Random Forest Toolbox for Matlab
by Mang Shao and Tae-Kyun Kim on June 20, 2014.

This Simple-RF toolbox is made for demonstrating randomised decision forest (RF) 
step-by-step, with commented guidelines, on several toy data sets and Caltech101 
image categoisation data set.

---------------------------------------------------------------------------
This code is inspired by Karpathy's toolbox (1) and MSR's work (2) on Random Forests:

1. https://github.com/karpathy/Random-Forest-Matlab
2. https://research.microsoft.com/apps/pubs/default.aspx?id=155552
---------------------------------------------------------------------------
The main scripts to run (from the main directory) are:
    main.m          - run demo script and display results
    main_guideline  - step-by-step walkthrough
    
Some important functions:
    
internal functions:

    getData.m           - Generate training and testing data
   
    growTrees.m         - Grow random forest, each decision tree has following structure:

           Base               Each node [trees(T).node(n)] stores:
          n=1                   node.idx       - data (index only) which split into this node
           / \                  node.t         - threshold of split function
          2   3                 node.dim       - feature dimension of split function
         / \ / \                node.prob      - class distribution of data in this node
        4  5 6  7               node.leaf_idx  - leaf node index (empty if it is not a leaf node) 
       ...........            Each leaf node [trees(T).leaf(m)]
                                leaf.label     - Assigned index of leaf node from the RF
                                leaf.prob      - class distribution of data in this leaf node
                              
    splitNode.m         - Update input tree node and split it into two child nodes 

    testTrees.m         - Run random forest on testing data, slow version (pass data vectors one-by-one)
    testTrees_fast.m    - faster version (pass all data vectors in one go)

external functions and libraries:
    
    VLFeat    - A large open source library implements popular computer vision algorithms. BSD License.
                http://www.vlfeat.org/index.html
    
    LIBSVM    - A library for support vector machines. BSD License
                http://www.csie.ntu.edu.tw/~cjlin/libsvm/

    mgd.m     - Generates a Multivariate Gaussian Distribution. BSD License
                Written by Timothy Felty
                http://www.mathworks.co.uk/matlabcentral/fileexchange/5984-multivariate-gaussian-distribution

    subaxis.m - Modified 'subplot' function. No BSD License
  parseArgs.s   Written by Aslak Grinsted
                http://www.mathworks.co.uk/matlabcentral/fileexchange/3696-subaxis-subplot

    suptitle.m- Create a "master title" at the top of a figure with several subplots
                Written by Drea Thomas

    Caltech_101 image categorisation dataset
                    L. Fei-Fei, R. Fergus and P. Perona. Learning generative visual models
                    from few training examples: an incremental Bayesian approach tested on
                    101 object categories. IEEE. CVPR 2004, Workshop on Generative-Model
                    Based Vision. 2004
                http://www.vision.caltech.edu/Image_Datasets/Caltech101/
---------------------------------------------------------------------------

BSD License. 

