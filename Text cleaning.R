library(tm)
library(stringr)

#build a corpus and specify the source to be character of vectors
#a corpus is a collection of written texts
myCorpus <- iconv(tweets.df$text, "ASCII", "UTF-8", sub="")
myCorpus <- tm_map(myCorpus, function(x) iconv(enc2utf8(x), sub = "byte"))
myCorpus <- Corpus(VectorSource(tweets.df$text))

#convert myCorpus into lowercase
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

#remove punctuation
myCorpus <- tm_map(myCorpus, removePunctuation)
#remove numbers
myCorpus <- tm_map(myCorpus, removeNumbers)
#remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*","", x)
myCorpus <- tm_map(myCorpus,removeURL)

#add stopwords
#stopwords are words which do not contain much significance.
#These words are usually filtered out because they return vast amount of unnecessary information.
mystopwords <- c(stopwords("english"))

#remove stopwords
myCorpus <- tm_map(myCorpus,removeWords,mystopwords)

#copy of corpus
myCorpus_copy <- myCorpus
#stem words
myCorpus <- tm_map(myCorpus,stemDocument)

#inspect the first 5 tweets
inspect(myCorpus[1:5])
#the code bellow enables the text to fit for paper width
p <- 1:5
for (i in 1:5){
  cat(paste("[",i,"]" , sep = ""))
  writeLines(myCorpus[i])
}

#stem completion
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=myCorpus_copy)
inspect(myCorpus[1:5])
inspect(myCorpus_copy[1:5])

tdm <- TermDocumentMatrix(myCorpus_copy,control = list(wordlengths = c(1,Inf)))
tdm

