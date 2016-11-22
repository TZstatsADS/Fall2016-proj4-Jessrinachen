require(arules)
require(arulesViz)
songs = lyr[,1]
lyr[,1] = NULL
rownames(lyr) = songs
lyr = apply(lyr,1,function(x) {x[x!=0] = 1;x})
lyr = t(lyr)
rules = apriori(lyr, parameter = list(support = 0.2, confidence = 0.6))
summary(rules)
inspect(head(rules, n = 30, by = "confidence"))
words = apply(lyr,2,sum)
rev(sort(words))[1:100]
a = sapply(names(words), function(x) try(nchar(x),silent = T))
toremove = match(c("the","that",names(words)[as.numeric(a) < 3]), names(words))
lyr2 = lyr[,-na.omit(toremove)]
rules = apriori(lyr2, parameter = list(support = 0.2, confidence = 0.6))
summary(rules)
inspect(head(rules, n = 30, by = "confidence"))

plot(rules, method="grouped", control=list(k=50))
subrules <- head(sort(rules, by="lift"), 30)
plot(subrules, method="graph")

