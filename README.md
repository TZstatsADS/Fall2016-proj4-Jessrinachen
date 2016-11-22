# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Yanxi Chen
+ Projec title: Word For Music

![words](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/words.png)

+ Project summary: In this project, we want to find the association between the features and lyrics then rank the possible words. I considered two method to build the recommendation system: 1. Similarity Matrix(cosine distance) 2. Topic Models.

+ Part1: Association Pattern

+ I explored the association patterns using association rule. After transforming the lyrics matrix into a binary output matrix, we would expect a relatively high confidence and support since lower values would generate too many rules. After several attempts, I set support=0.2 and confidence=0.6. This still gives 1 million plus rules. I realized that there are many very common words like, 'is', 'it'. The words seem not meaningful as we want to find association rules among some featured words. Next, from the frequency of the words, I noticed that there are many words that can be removed since we do not have interests on them. Such as 'the', 'it', and 'is'. I actually eliminated all the words that have less than 3 letters.Then， with the 0.2 support and 0.6 confidence we obtain 1882 rules. After this procedure, the result looks better afterward and notice that all the top 30 on the left hand side indicate on their Right hand side the word {you}. 


+ Visualizing Association Rules


![Visualizing association rules]( https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/visualizing%20association%20rules.png)


+ Part2: Basic Methods of recommendation system:

+ Method 1: Similarity Matrix(Cosine Distance):

+ Since we want to find the association between the new 100 songs and the 5000 dictionary words. We can use this 2350 songs as latent factor, then connect new songs and this old set of songs using distance based similarities(cosine distance). It is a matrix with dimension of 100*2350, and then we can multiply it by this known song-words matrix(which is a known connection). This works since we find similarities between the training songs and the testing songs, then we continue to find the dictionary words in the training data set. Her ewe use all of the training songs with weights based on similarities. For this method, I extracted mean and standard deviation of the features. Please find the code in the /lib folder.


+ Method 2: Topic Models

+ Cluster Analysis. 


![kmeans_cluster](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/kmeans_cluster.png)


+ A plot of the within groups sum of squares by number of clusters shows that the 22~25 clusters are Suitable for the MSD dataset. 


![Ward.D2 hierachical cluster](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/hclust.png)

![hclust_phylo](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/hclust_phylo.png)

+ Ward.D2 hierachical clustering with cosine distance using the clustering effect.


![number of topics_1](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/Perplexity2_1gibbs5_100.png)

![number_of_topics_2](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/LogLikelihood2_gibbs5_100.png)


+ Ward.D2 hierarchical clustering with cosine distance using the clustering effect Based on perplexity and loglikelihood for different topic k model, the 20-25 topic model is better.

+ I considered the model of LDA_VEM, LDA_VEM_fixed, LDA_Gibbs, CTM for the 2350 songs. Assuming the number of topic k is equal to 22, the probability distributions of the four models to the most probable topic are as follows. 

![probability](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/maxProb.png)

+ It is easy to see that LDA_VEM and CTM of the topic is relatively dispersed. It is easy to see that LDA_VEM and CTM Of the topic is relatively dispersed, the perplexity of LDA_Gibbs is the minimum, therefore, the LDA_Gibbs algorithm is the best.

![probability](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/Cosine_LDA_VEM%20VS%20LDA_GIBBS.png)

+ According to the matrix, LDA_VEM and LDA_Gibbs cosine similarity of topics as in the figure. The lighter (yellow) the color, the higher the similarity.

+ Topic Model Visualization

![Topic model visualization](https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/Topic%20model%20visual.png)




Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
