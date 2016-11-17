require(tm)
load("lyr.RData")
lyr.num <- nrow(lyr)
rownames(lyr) <- lyr[,1]
lyr.id <- lyr[,1]
lyr.word <- iconv(colnames(lyr), "latin1",)[-1]
lyr <- as.data.frame(t(lyr[,-1]))

generate.lyr <- function(x, lyr.word) {
  pos <- x > 0
  num <- c(x[pos])
  if(length(pos) > 1){
    word <- c(lyr.word[pos])
    lyr <- rep(word, num)
  } else {
    lyr <- word
  }
  lyr
}
lyr.list <- lapply(as.list(lyr), generate.lyr, lyr.word)


lyr.dtm <- DocumentTermMatrix(tm_map(Corpus(VectorSource(lyr.list)), content_transformer(tolower)), 
                   control = list(weighting = function(x) weightTfIdf(x, normalize = FALSE)))
  
lyr.dtm.matrix <- as.matrix(lyr.dtm)

lyr.dtm.cluster <- removeSparseTerms(lyr.dtm, 0.8)
	
sample.flag <- sample(lyr.num)%%10+1

# lyr.dtm.df.train <- as.data.frame(lyr.dtm.matrix[sample.flag <= 8, ])
# lyr.dtm.df.test <- as.data.frame(lyr.dtm.matrix[sample.flag  > 8, ])
lyr.dtm.df.train <- as.data.frame(lyr.dtm.matrix)

