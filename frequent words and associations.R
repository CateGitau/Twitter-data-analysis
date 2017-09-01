#inspect frequent words
freq.terms <- findFreqTerms(tdm,lowfreq = 10)
View(freq.terms)

termFreq <- rowSums(as.matrix(tdm))
termFreq <- subset(termFreq, termFreq >=10)
df <- data.frame(term = names(termFreq), freq = termFreq)

View(df)

library(ggplot2)
ggplot(df,aes(x = term, y = freq)) + geom_bar(stat = "identity") + xlab("Terms") + ylab("Count") + coord_flip()

#find words which are associated with nasa
findAssocs(tdm, "iebc", 0.2)

