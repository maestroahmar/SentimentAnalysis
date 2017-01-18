library(twitteR)
library(qdapDictionaries)
args <- commandArgs(TRUE)
consumer_key <- "cjBy9KvC95Cg5XfEFDs1y8MH5"
consumer_secret <- "WlMAkoZtvalN9cAbs24kbdyB953rhDTfFcvWpTAZm8VfdNbphD"
access_token <- " 380908509-EYQ0TQqKY7xnoRD1wboeYaQsHLYWnUPFPgCRfGhc"
access_secret <- "2XWL29B7EIE3nZru5av9t9Zg7Sb6bl50z1jNaASQ0b6jo"
access_token <- "380908509-EYQ0TQqKY7xnoRD1wboeYaQsHLYWnUPFPgCRfGhc"
names_movies <- as.integer(args[1])

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tweets <- searchTwitter(names_movies,n=100)
tweets <- strip_retweets(tweets)
tweet_txt = sapply(tweets, function(x) x$getText())
tweet_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweet_txt)
tweet_txt = gsub("@\\w+", "", tweet_txt)
tweet_txt = gsub("[[:digit:]]", "", tweet_txt)
tweet_txt = gsub("[[:punct:]]", "", tweet_txt)
tweet_txt = gsub("http\\w+", "", tweet_txt)
tweet_txt = gsub("^\\s+|\\s+$", "", tweet_txt)
tweet_txt = gsub("[ \t]{2,}", "", tweet_txt)
tweet_txt = gsub("amp", "", tweet_txt)


for(i in tweet_txt)
{
tw <- strsplit(i," ")[[1]]
for(j in tw)
{
if(j %in% positive.words)
print (j);
}

}



