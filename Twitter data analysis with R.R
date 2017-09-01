#install required packages
install.packages("twitteR")
install.packages("RCurl")
install.packages("httr")
install.packages("devtools")
devtools::install_github("r-lib/httr")

#Load necessary packages
library(twitteR)
library(RCurl)
library(base64enc)

# XXX: Go to http://dev.twitter.com/apps/new to create an app and get values
# for these credentials, which you'll need to provide in place of these
# empty string values that are defined as placeholders.
# See https://dev.twitter.com/docs/auth/oauth for more information 
# on Twitter's OAuth implementation.
Access_token <-  "92508756-jfMBTMdZbC3lOAga4NHu7c7DpE4oDwM2HnHfUs3MA"
Access_token_secret <-  "0U02wiesBamBvLQI7DZlNFOlqiaedp0jt9Lk9d8oYEuNA"
consumer_key <-  "esFEPTaTjCE4NzCwN6UD2ZmUq"
consumer_secret <-  "xyTSL0I7nbJN7slYuahh7TlFqpEPpsLZwcrFUfa0wprqCUpgEf"

setup_twitter_oauth(consumer_key,consumer_secret,Access_token,Access_token_secret)

#Get Tweets
IEBC_Tweets <- searchTwitter("IEBC", n=100, lang = "en")

#convert the tweets into a df
tweets.df <-twListToDF(IEBC_Tweets) 
dim(tweets.df)

library(tm)

#build a corpus and specify the source to be character of vectors
#a corpus is a collection of written texts
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
mystopwords <- c(stopwords("english"),"rt")

#remove stopwords
myCorpus <- tm_map(myCorpus,removeWords,mystopwords)

#copy of corpus
myCorpus_copy <- myCorpus
#stem words
myCorpus <- tm_map(myCorpus,stemDocument)

#inspect the first 5 tweets
inspect(myCorpus[1:5])
#the code bellow enables the text to fit for paper width

for (i in 1:5){
  cat(paste("[[", i,"]]" , sep = ""))
  writeLines(myCorpus[[i]])
}

#stem completion
myCorpus <- tm_map(myCorpus, stemCompletion, dictionary=myCorpus_copy)
inspect(myCorpus[1:5])
inspect(myCorpus_copy[1:5])

tdm <- TermDocumentMatrix(myCorpus,control = list(wordlengths = c(1,Inf)))
tdm

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

source("http://bioconductor.org/biocLite.R")
biocLite(c("graph", "RBGL", "Rgraphviz"))
library(graph)
