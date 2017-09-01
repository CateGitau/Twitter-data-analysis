source("http://bioconductor.org/biocLite.R")
biocLite(c("graph", "RBGL", "Rgraphviz"))
library(graph)
library(Rgraphviz)
plot(tdm,term=freq.terms, corThreshold = 0.12, weighting = T)

library(wordcloud)
m <- as.matrix(tdm)

# colors
pal <- brewer.pal(9, "BuGn")
pal <- pal[-(1:4)]

#calculate the frequency of words as sort it by frequency
word.freq <- sort(rowSums(m), decreasing = T)
wordcloud(words = names(word.freq), freq = word.freq, min.freq = 3, random.order = FALSE,colors = pal)

