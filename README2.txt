Answers

Q1

Size of each data subset?

Bagging was performed with replacement, with each data subset size equal to the size of the original dataset. This ensured that about 63.2% of the data samples were unique, and the remaining 36.8% contained duplicates. Figure 1 shows the visualisation of four different data subsets.

By using this method, each data segment was treated as being independant of each other, so that they always had the same probability of being chosen. It also caused each data subset to include a different group of duplicates, and therefore each subset was weighted towards a different group of data samples. This allowed the nodes to be biased less by outliers, as they would be weighted relatively lower. The overall differences in weighting between the trees later become averaged out in the decision forest, so this does not cause any long term negative impact.

Each tree started with a single node which was then split. An example of this can be seen in Figure 2. The spliting was performed according to randomised criteria, such as which axis the split would be aligned with, and what the threshold would be. Each node was split thrice, and the information gain was calculated each time. The split with the highest information gain was than chosen to determine the child nodes, upon which the process was repeated. 

[we could possibly choose a different figure 2 with clearer classification?]

Even when choosing the best initial split, the information gain is relatively low. This is because it requires more split boundaries to clearly distinguish between classes due to the relatively complex spiral shape of the class feature (?) distribution.

In Figure 2, the highthe split function value was -0.38, so that any data with a greater value would be placed in the left node, and any with a lower value would be placed in the right node.




