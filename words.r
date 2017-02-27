library(twitteR) 
s <- 0
smiley_count <- 0
words_count <- 0
neg <- 0
pos <- 0
consumer_key <- "iS71TIxdgtjMn90IhtqMKqscn"
consumer_secret <- "rmFMbW3BnYQK82Sk7orrlE1jdrOi54LWtd851x7GXgxfZELza8"
access_token <- "380908509-EYQ0TQqKY7xnoRD1wboeYaQsHLYWnUPFPgCRfGhc"
access_secret <- "2XWL29B7EIE3nZru5av9t9Zg7Sb6bl50z1jNaASQ0b6jo"
#credentials for accessing twitter tweets
args <- commandArgs(TRUE) 
names_movies <- as.integer(args[1])
actor <- as.integer(args[2])
#movie name and actor input from php file
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
#setting up twitter authentication
tweets <- searchTwitter(names_movies,n=100, resultType = "recent")
#search for particular movie along with actor
#tweets <- strip_retweets(tweets)
#removing the retweets which are repeated more than once.

#Cleaning Data
tweet_txt = sapply(tweets, function(x) x$getText())
#Getting tweets in text format.
tweet_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweet_txt)
#removing via mentions, RT.
tweet_txt = gsub("@\\w+", "", tweet_txt)
#removing the @ mentions
tweet_txt = gsub("[[:digit:]]", "", tweet_txt)
#removing unnecessary numbers
tweet_txt = gsub("http\\w+", "", tweet_txt)
#removing any unnecessary links
tweet_txt = gsub("^\\s+|\\s+$", "", tweet_txt)
tweet_txt = gsub("[ \t]{2,}", "", tweet_txt)
#removing & symbols
tweet_txt = gsub("amp", "", tweet_txt)

#reading the words along with their weights.
val <- read.table("tweets_val.txt",header=F,sep="\t",quote="",col.names=c("term","score"))
#reading smiley symbols along with their weights
smi <- read.table("smileys.txt",col.names=c("smiley","score"))

#searching for words to match with the list provided.
for(i in tweet_txt)
{
tw <- strsplit(i," ")[[1]]
for(j in tw)
{
	if(j %in% smi[,1])
	{

		s <- s + smi[which(smi$smiley == j),2]
		#add the weight collected from the words
		smiley_count = smiley_count + 1

		if(smi[which(smi$smiley == j),2] < 0)
		{
			neg <- neg + 1;
		}
		else
		{
			pos <- pos + 1;

		}

		
	}
	
	if(j %in% val[,1])
	{

	s <- s + val[which(val$term == j),2]
	words_count = words_count + 1
	if(val[which(val$term == j),2] < 0)
		{
			neg <- neg + 1;
		}
		else
		{
			pos <- pos + 1;

		}
	
	}

		
}

}
#write the value to a text file.
write(s,file='ratings.txt',append=TRUE)
print(s)



