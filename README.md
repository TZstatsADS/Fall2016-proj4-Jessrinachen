# Project: Words 4 Music

### [Project Description](doc/Project4_desc.md)

![image](http://cdn.newsapi.com.au/image/v1/f7131c018870330120dbe4b73bb7695c?width=650)

Term: Fall 2016

+ [Data link](https://courseworks2.columbia.edu/courses/11849/files/folder/Project_Files?preview=763391)-(**courseworks login required**)
+ [Data description](doc/readme.html)
+ Contributor's name: Yanxi Chen
+ Projec title: Word For Music
+ Project summary: In this project, we want to find the association between the features and lyrics then rank the possible words. I considered two method to build the recommendation system: 1. Similarity Matrix(cosine distance) 2. Topic Models

+ Part1: Association Pattern

+ I explored the association patterns using association rule. After transforming the lyrics matrix into a binary output matrix, we would expect a relatively high confidence and support since lower values would generate too many rules. After several attempts, I set support=0.2 and confidence=0.6. This still gives 1 million plus rules. I realized that there are many very common words like, 'is', 'it'. The words seem not meaningful as we want to find association rules among some featured words. Next, from the frequency of the words, I noticed that there are many words that can be removed since we do not have interests on them. Such as 'the', 'it', and 'is'. I actually eliminated all the words that have less than 3 letters.Then， with the 0.2 support and 0.6 confidence we obtain 1882 rules. After this procedure, the result looks better afterward and notice that all the top 30 on the left hand side indicate on their Right hand side the word {you}. 



![Visualizing association rules]( https://github.com/TZstatsADS/Fall2016-proj4-Jessrinachen/blob/master/figs/visualizing%20association%20rules.png)


+ Part2: Basic Methods of recommendation system:

+ 1. Similarity Matrix(Cosine Distance):

+ Since we want to find the association between the new 100 songs and the 5000 dictionary words. We can use this 2350 songs as latent factor, then connect new songs and this old set of songs using distance based similarities(cosine distance). It is a matrix with dimension of 100*2350, and then we can multiply it by this known song-words matrix(which is a known connection). This works since we find similarities between the training songs and the testing songs, then we continue to find the dictionary words in the training data set. Her ewe use all of the training songs with weights based on similarities. For this method, I extracted mean and standard deviation of the features. Please find the code in the /lib folder.

+ 2. Topic Models

+ First, I made a cluster analysis. A plot of the within groups sum of squares by number of clusters shows that the 22~25 clusters are Suitable for the MSD dataset. Ward.D2 hierarchical clustering with cosine distance using the cluster effect is shown in the /fig folder. Based on perplexity and loglikelihood for different topic k model, the 20-25 topic model is better.
+ Next, I considered the LDA_VEM, LDA_VEM Fixed, LDA_Gibbs and CTM for the 2350 songs. Assuming the number of topic k is equal to  22, the probability distributions of the four models to the most probable topic are It is easy to see that LDA_VEM and CTM Of the topic is relatively dispersed, and LDA_VEM_fixed LDA_Gibbs and a few themes in a larger proportion, LDA_Gibbs the degree of confusion is minimal. Assuming the number of subjects k = 22, the probability distributions of the four models to the most probable topic are as follows. It is easy to see that LDA_VEM and CTM Of the topic is relatively dispersed, in contrast LDA_VEM_fixed and LDA_Gibbs are a few themes in a larger proportion, the perplexity of LDA_Gibbs  is minimal, therefore, the LDA_Gibbs  algorithm is the best.

I actually eliminated all the words that have less than 3 letters. 
Then, with the 0.2 support and 0.6 confidence we obtain one thousand eight hundred eighty two rules.

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
