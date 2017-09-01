#install required packages
install.packages("twitteR")
install.packages("RCurl")
install.packages("httr")
install.packages("devtools")
install.packages(toInstall, repos = "http://cran.r-project.org")
library(devtools)

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

#Calling twitteR OAuth function
setup_twitter_oauth(consumer_key,consumer_secret,Access_token,Access_token_secret)

#Extracting Trends using getTrends Function
KE_WOE_ID = 23424863
current_trends  <-  getTrends(KE_WOE_ID)
View(current_trends)

#counting the number of tweets that match a certain condition

#Get Tweets
tweets <- userTimeline("ranftjym", n= 100)
Tweets_ <- searchTwitter("#SupremeCourtDecides", n=150, lang = "en")

#convert the tweets into a df
tweets.df <-twListToDF(Tweets_)
dim(tweets.df)

