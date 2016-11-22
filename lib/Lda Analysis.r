
library(tm)
library(slam)
library(topicmodels)
library(wordcloud)
library(jiebaR)

# LDA analysis
term.table <- table(unlist(lyr.list)) 

term.table <- sort(term.table, decreasing = TRUE) 

del <- term.table < 5| nchar(names(term.table))<2   
term.table <- term.table[!del]   
vocab <- names(term.table)   

get.terms <- function(x) {
  index <- match(x, vocab)  
  index <- index[!is.na(index)]  
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))   
}
lyc.documents <- lapply(lyr.list, get.terms)


####################################
DTM_Topic_SUM<-function(dtm,class){
  #n=length(class)
  m=length(table(class))
  x<-dtm[1:m,]
  row.names(x)<-paste('Topic',1:m,sep="_")
  #x=simple_triplet_zero_matrix(nrow=m,ncol=ncol(dtm))
  for( i in 1:m){
    x[i,]<-col_sums(dtm[class==i,])
  }
  #colnames(x)<-colnames(dtm)  
  x
}

vemsum<-DTM_Topic_SUM(lyr.dtm.tf,vem_class)
Gibbssum<-DTM_Topic_SUM(lyr.dtm.tf,DF2[991:1485,1])
dim(vemsum)
vemsum<-as.matrix(vemsum)
Gibbssum<-as.matrix(Gibbssum)
#########################################
cosine<-function(x){
  .cosine<-function(x,y){
    x<-as.vector(x)
    y<-as.vector(y)
    sum(x*y)/(sqrt(sum(x^2))*sqrt(sum(y^2)))
  }
  nr<-nrow(x)
  simmat<-matrix(nrow=nr,ncol=nr)
  for(i in 1:nr){
    for(j in i:nr){
      simmat[i,j]<-.cosine(x[i,],x[j,])
    }
  }
  return(simmat)
}

sim<-cosine(vemsum)
sim2<-cosine(Gibbssum)
png('fig/cosine.png',width=950,height=480)
par(mfrow=c(1,2),mar=c(2,2,2,0))
image(sim,xaxt="n", yaxt="n",main="LDA_VEM")
axis(1, at=seq(0,1,length=8),labels=paste('Topic',1:8), tick=F ,line=-.5)
axis(2, at =seq(0,1,length=8),label=paste('Topic',1:8))
image(sim2,xaxt="n", yaxt="n",main="LDA_Gibbs")
axis(1, at=seq(0,1,length=8),labels=paste('Topic',1:8), tick=F ,line=-.5)
axis(2, at =seq(0,1,length=8),label=paste('Topic',1:8))
dev.off()


K <- 22   
G <- 5000   
alpha <- 0.10   
eta <- 0.02

library(lda) 
set.seed(357) 
fit.lda <- lda.collapsed.gibbs.sampler(documents = lyc.documents, K = K, vocab = vocab, num.iterations = G, alpha = alpha, eta = eta, initial = NULL, burnin = 0, compute.log.likelihood = TRUE)

theta <- t(apply(fit.lda$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(fit.lda$topics) + eta, 2, function(x) x/sum(x)))
term.frequency <- as.integer(term.table)
doc.length <- sapply(lyc.documents, function(x) sum(x[2, ]))



# Predict new words for the first two documents

predictions <-  predictive.distribution(fit.lda$document_sums[,sample.flag==1], fit.lda$topics, alpha=alpha, eta=eta)

# Use top.topic.words to show the top 5 predictions in each document.
predict <- as.data.frame(top.topic.words(t(predictions), 5000))
colnames(predict) <- lyr.id[sample.flag==1]

