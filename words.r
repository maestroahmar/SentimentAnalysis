library(twitteR)
s <- 0
smiley_count <- 0
words_count <- 0
consumer_key <- "iS71TIxdgtjMn90IhtqMKqscn"
consumer_secret <- "rmFMbW3BnYQK82Sk7orrlE1jdrOi54LWtd851x7GXgxfZELza8"
access_token <- "380908509-EYQ0TQqKY7xnoRD1wboeYaQsHLYWnUPFPgCRfGhc"
access_secret <- "2XWL29B7EIE3nZru5av9t9Zg7Sb6bl50z1jNaASQ0b6jo"
args <- commandArgs(TRUE)
names_movies <- as.integer(args[1])
actor <- as.integer(args[2])
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tweets <- searchTwitter(names_movies,n=500, resultType = "recent")
tweets <- strip_retweets(tweets)
tweet_txt = sapply(tweets, function(x) x$getText())
tweet_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweet_txt)
tweet_txt = gsub("@\\w+", "", tweet_txt)
tweet_txt = gsub("[[:digit:]]", "", tweet_txt)
tweet_txt = gsub("http\\w+", "", tweet_txt)
tweet_txt = gsub("^\\s+|\\s+$", "", tweet_txt)
tweet_txt = gsub("[ \t]{2,}", "", tweet_txt)
tweet_txt = gsub("amp", "", tweet_txt)
val <- read.table("tweets_val.txt",header=F,sep="\t",quote="",col.names=c("term","score"))
smi <- read.table("smileys.txt",col.names=c("smiley","score"))
 
for(i in tweet_txt)
{
tw <- strsplit(i," ")[[1]]
for(j in tw)
{
	if(j %in% smi[,1])
	{

		s <- s + smi[which(smi$smiley == j),2]
		smiley_count = smiley_count + 1
		
	print(i)
	}
	
	if(j %in% val[,1])
	{

	s <- s + val[which(val$term == j),2]
	words_count = words_count + 1
	
	
	}

		
}

}
write.table(c(names_movies,s),file='ratings.csv',append=TRUE)
print(s)



