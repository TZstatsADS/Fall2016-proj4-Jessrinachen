#Features
library(rhdf5)
library(pbapply)
library(magrittr)
#modified function obtain more features, include some basic statistics for complex features
get.features <- function(files.list, directory){
  
  # counters to see progress
  num <- 0  
  total <- length(files.list)
  
  # Loop through all the data files, collect results as a list.
  features <- pblapply(files.list, function(x, dir){
    
    file <- paste0(dir,x)
    h5f <- h5dump(file, load = TRUE)
    analysis <- h5f$analysis
    tempo <- analysis$songs$tempo
    #added
    md <- analysis$songs$mode
    md_ci <- analysis$songs$mode_confidence
    loudness <- analysis$songs$loundness
    analysis$songs <- NULL
    analysis$segments_timbre <- NULL
    analysis$segments_pitches <- NULL
    features_mean <- unlist(lapply(analysis,mean, na.rm = T))
    features_sd <- unlist(lapply(analysis,sd, na.rm = T))
    song <- substr(x, start = 7, stop = nchar(x)-3)
    H5close()
    return(c(song,features_mean, features_sd))
  },
  dir = directory
  )
  
  file <- paste0(directory,files.list[1])
  h5f <- h5dump(file, load = TRUE)
  analysis <- h5f$analysis
  analysis$songs <- NULL
  analysis$segments_timbre <- NULL
  analysis$segments_pitches <- NULL
  names_mean = paste0("mean_",names(analysis))
  names_sd = paste0("sd_",names(analysis))
  H5close()
  # Transform list into a data frame
  song.features.df <- unlist(features) %>% 
    matrix(byrow = TRUE, ncol = length(features[[1]])) %>%
    data.frame()
  names(song.features.df) <- c("song",names_mean,names_sd)
  for(j in 2:ncol(song.features.df))
  song.features.df[,j] = as.double(as.character(song.features.df[,j]))
  return(song.features.df)
}





dir.h5 <- 'data/'
files.list <- as.matrix(list.files(dir.h5, recursive = TRUE))
song.features.df <- get.features(files.list, dir.h5)
song.features.df2 <- apply(song.features.df[,-1], 2, function(x) {
  x[is.nan(x)|is.na(x)] = mean(x[!(is.nan(x)|is.na(x))])
  x
})
song.features.df <-  data.frame(song =  song.features.df[,1], song.features.df2)
save(song.features.df, file = "songfeatures.rdata")
#load the features

#Run in testing

load("songfeatures.rdata")

song.features.df = song.features.df[ ,-c(2:4)]
View(song.features.df)
#load bag of words
load("lyr.RData")


#ranking

newdir.h5 <- '/Users/jesserina/Desktop/TestSongFile100/'
newfiles.list <- as.matrix(list.files(newdir.h5, recursive = TRUE))
newsong.features.df <- get.features(newfiles.list[-1], newdir.h5)
newsong.features.df2 <- apply(newsong.features.df[,-1], 2, function(x) {
   x[is.nan(x)|is.na(x)] = mean(x[!(is.nan(x)|is.na(x))])
   x
 })
newsong.features.df <-  data.frame(song =  newsong.features.df[,1], newsong.features.df2)
df <- rbind(newsong.features.df, song.features.df)
df <- scale(df[,-1])
newsong.features.df <- data.frame(song = newsong.features.df[,1], df[1:100,])
newsong.features.df
song.features.df <- data.frame(song = song.features.df[,1], df[-(1:100),])
#compute similarities between new songs and the given 2500 songs 
#based on cosine distance

mat <- apply(newsong.features.df[,-1], 1, function(x) {
  apply(song.features.df[,-1], 1, function(y) {
    0.5 + 0.5*sum(x*y)/sqrt(sum(x^2)*sum(y^2))
  })
})
similar <- t(mat)  

rownames(similar) <- newsong.features.df[,1]
colnames(similar) <- song.features.df[,1]
similar <- apply(similar, 1, function(x) {
  x/sum(x,na.rm = T)
})
similar <- t(similar)
View(similar)

poses <- match(colnames(similar), lyr[,1])
lyr2 <- lyr[poses, ]
#100*2500 x 2500*5000 = 100*5000
words_ranking <- similar %*% as.matrix(lyr2[,-1])
song = substr(rownames(words_ranking),11,30)
col_n = colnames(words_ranking)
colnames(words_ranking) = 1:5000
df = data.frame(song ,words_ranking, stringsAsFactors = F)
numer = substr(df$song,9,20)
df2 = df[order(as.integer(numer)),]
rownames(df2) = 1:nrow(df2)
aa = apply(df2[,-1],1, function(x)  5001 - rank(x))
df2[,-1]=aa
colnames(df2)[-1] = col_n
write.csv(df2,file = "submission.csv")

# #words_ranking <- t(words_ranking)
# View(words_ranking )
# bests <- colnames(lyr2)[apply(words_ranking,2,which.max)]
# bests

# require(arules)
# require(arulesViz)
# songs = lyr[,1]
# lyr[,1] = NULL
# rownames(lyr) = songs
# lyr = apply(lyr,1,function(x) {x[x!=0] = 1;x})
# lyr = t(lyr)
# rules = apriori(lyr, parameter = list(support = 0.2, confidence = 0.6))
# summary(rules)
# inspect(head(rules, n = 30, by = "confidence"))
# words = apply(lyr,2,sum)
# rev(sort(words))[1:100]
# a = sapply(names(words), function(x) try(nchar(x),silent = T))
# toremove = match(c("the","that",names(words)[as.numeric(a) < 3]), names(words))
# lyr2 = lyr[,-na.omit(toremove)]
# rules = apriori(lyr2, parameter = list(support = 0.2, confidence = 0.6))
# summary(rules)
# inspect(head(rules, n = 30, by = "confidence"))
# 
# plot(rules, method="grouped", control=list(k=50))
# subrules <- head(sort(rules, by="lift"), 30)
# plot(subrules, method="graph")

