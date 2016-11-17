# cluster analysis
# Determine number of clusters
wss <- (nrow(lyr.dtm.df.train)-1)*sum(apply(lyr.dtm.df.train,2,var))
cluster.vector <- c(5:30)

for (i in cluster.vector) {
  cat("The cluster number: ", i, "\n")
  wss[i] <- sum(kmeans(lyr.dtm.df.train,centers=i)$withinss)
  gc()
}
png(paste0(getwd(), "./fig/keamns_cluster.png"), 
    width=5, height=5, 
    units="in", res=700)
plot(cluster.vector,wss[cluster.vector], type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares", cex = 1, main = "The number of clusters in lyr")
text(cluster.vector, wss[cluster.vector])
dev.off()

# Ward Hierarchical Clustering
require(proxy)
cosine = function(a,b) { 
  len = (sqrt(a %*% a)*sqrt(b %*% b)); 
  if (len == 0) { 
    0; 
  } else { 
    (a %*% b)/len; 
  } 
}
d <- dist(lyr.dtm.df.train, method = "cosine") # distance matrix
fit.hclust <- hclust(d, method="ward.D2") 

# draw dendogram with red borders around the 5 clusters 
png(paste0(getwd(), "./fig/hclust.png"), 
    width=5, height=5, 
    units="in", res=700)
plot(fit.hclust, labels = FALSE,hang = -5) # display dendogram
groups <- cutree(fit.hclust, k = 22) # cut tree into 22 clusters
rect.hclust(fit.hclust, k = 22, border="red") 
dev.off()

require(apTreeshape)
png(paste0(getwd(), "./fig/hclust_phylo.png"), 
    width=5, height=5, 
    units="in", res=700)
plot(as.phylo(fit.hclust), type = "fan")
dev.off()