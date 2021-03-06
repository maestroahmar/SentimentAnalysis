library(twitteR) 
#twitteR is an R package which provides access to the Twitter API. Most functionality of the API is supported, with a bias towards API calls that are more useful in data analysis as opposed to daily interaction.

s <- 0
smiley_count <- 0
words_count <- 0
fneg <- 0
fpos <- 0
neg <- 0
pos <- 0
fin <- 0
single_neg <- c()
single_pos <- c()
total <- c()
# Instance/Platform variables that are responsible for holding the values of certain parameters of the calculation
consumer_key <- "2vHmWf7E7xQbYgdNopRvMKEoN"
#Consumer keys are also known as API keys. You'll also need your consumer secret. To make API calls, you'll also need an access token and access token secret, collectively called an "oauth token" -- they represent a user making a request
consumer_secret <- "pae5qfjbopFGHjbzCGGdYsEcXBtAijouV8VEVQwbzs8Rzn215z"
#onsumer secret is the client password that is used to authenticate with the authentication server, which is a Twitter/Facebook/etc. server that authenticates the client. Access token is what is issued to the client once the client successfully authenticates itself (using the consumer key & secret).
access_token <- "380908509-EYQ0TQqKY7xnoRD1wboeYaQsHLYWnUPFPgCRfGhc"
#An access token is an object that describes the security context of a process or thread. The information in a token includes the identity and privileges of the user account associated with the process or thread. ... The security identifier (SID) for the user's account. SIDs for the groups of which the user is a member.
access_secret <- "2XWL29B7EIE3nZru5av9t9Zg7Sb6bl50z1jNaASQ0b6jo"
#Access token is what is issued to the client once the client successfully authenticates itself (using the consumer key & secret). This access token defines the privileges of the client (what data the client can and cannot access). Now every time the client wants to access the end-user's data, the access token secret is sent with the access token as a password (similar to the consumer secret).
#credentials for accessing twitter tweets
#args <- commandArgs(TRUE) 
#Command Line Arguments for getting the name of the movie that is being passed in the PHP file (base) which is stored here in a variable.
#names_movies <- as.character(args[1])
#actor <- as.character(args[2])
#title <-  as.character(args[3])
#poster <- as.character(args[4])

search_term <- as.matrix(read.table("movies_list.csv",header=F))

#Paste function is used to concatenate the names of the movie and actor to search the keyword on  Twitter. 
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)


#The received parameter is an array moreover a list that has the name of the movie and actor as [1] and [2] position.
#movie name and actor input from php file
tmp <- 0
for(srch in search_term)
{
tmp <- tmp + 1
#search_key <- paste(names_movies,actor,sep=' ')
#print(srch)
#setting up twitter authentication with  all the parameters the session is setup for secure authentication.
tweets <- searchTwitter(srch,n=100, resultType = "recent")
#search for particular movie along with actor with this function, the function contains atleast 2 variables, one is the text that is searched on the Twitter DB, other one is the number of the tweets that should be searched for
#NOTE- If the number of mentions do not match  the number provided or is less than the number, then complete search is not done, it is stopped.
#tweets <- strip_retweets(tweets)
#removing the retweets which are repeated more than once.

#Cleaning Data
tweet_txt = sapply(tweets, function(x) x$getText())
#Getting tweets in text format.Instead of using for loop  to iterate through all tweets, we use apply functions so that a common operation is applied to  all.
tweet_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweet_txt)
#removing via mentions, RT via Regular Expressions.
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
setwd("C:\\Users\\Ahmar Zafar\\Desktop\\SentimentAnalysis-master")
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
			fneg <- fneg + 1;
			neg <- neg + smi[which(smi$smiley == j),2]
			single_neg <- append(single_neg,smi[which(smi$smiley == j),2])
		}
		else
		{
			fpos <- fpos + 1;
			pos <- pos + smi[which(smi$smiley == j),2]
			single_pos <- append(single_pos,smi[which(smi$smiley == j),2])

		}

		
	}
	
	if(j %in% val[,1])
	{

	s <- s + val[which(val$term == j),2]
	words_count = words_count + 1
	if(val[which(val$term == j),2] < 0)
		{
			fneg <- fneg + 1;
			neg <- neg + val[which(val$term == j),2]
			single_neg <- append(single_neg,smi[which(smi$smiley == j),2])
		}
		else
		{
			fpos <- fpos + 1;
			pos <- pos + val[which(val$term == j),2]
			single_pos <- append(single_pos,smi[which(smi$smiley == j),2])
		}
	
	}

		
}

}
#print("TOTAL NUMBER OF POSITIVES")
#print(fpos)
#print("TOTAL VALUE OF POSITIVES")
#print(pos)
#print("AVERAGE POSITIVE RATING GIVEN")
#print(pos/fpos)
#print("TOTAL NUMBER OF NEGATIVES")
#print(fneg)

#print("TOTAL VALUE OF NEGATIVES")

#print(neg)

#print("AVERAGE NEGATIVE RATING GIVEN")

#print(neg/fneg)


#print(avgneg)
#print(avgpos)



#write the value to a text file.
if (fpos > fneg)
{
fin <- 10*(1-((exp((-1)*(fpos/pos)))*(exp((fneg/neg))))) + ((fpos-fneg)/(fpos+fneg)) 
}
if(fpos <= fneg)
{
fin <- 10*(1-((exp((-1)*(fpos/pos)))*(exp((fneg/neg)))) - ((fpos-fneg)/(fpos+fneg))) 

}
if(fpos != 0 && fneg != 0)
	{
	if((fpos/(fpos+fneg) > .5) && (fin < 7) )
	{
	fin <- fin + (fpos/(fpos+fneg))
	}

	else if((fpos/(fpos+fneg) > .5) && (fin < 8))
	{
	fin <- fin + ((fpos/(fpos+fneg)*.75)) 
	}
	else if((fpos/(fpos+fneg) > .5) && (fin < 9.5))
	{
	fin <- fin + ((fpos/(fpos+fneg)*.25))
	}

	if((fneg/(fpos+fneg) > .4))
	{
	fin <- fin - (fpos/(fpos+fneg))
	}


if(fin > 9.8)
{
fin <- 9.8
}
}
if(fneg == 0)
{
	fin <- 10*(1-((exp((-1)*(fpos)))))
	if(fin < 9)
	fin <- fin + ((fpos-fneg)/(fpos+fneg))
}
if(fpos == 0)
{
	fin <- 0
}
print(fin)
slices <- c(fpos,fneg)
lbls <- c("Positive Tweets","Negative Tweets")
setwd("C:\\Users\\Ahmar Zafar\\Desktop\\SentimentAnalysis-master\\Website\\images")
fname <- paste(tmp,".png",sep="")
png(file=fname)
pie(slices,lbls,col = rainbow(length(slices)),main=srch)
dev.off()
struct <- list(pos,fpos,neg,fneg,fin)
setwd("C:\\Users\\Ahmar Zafar\\Desktop\\SentimentAnalysis-master\\Website")
single_neg <- single_neg * (-1)

write.table(struct,file='complete.csv',sep=',',append=T,col.names=F,row.names=F)
total <- append(total,fin)
s <- 0
smiley_count <- 0
words_count <- 0
fneg <- 0
fpos <- 0
neg <- 0
pos <- 0
fin <- 0

}
setwd("C:\\Users\\Ahmar Zafar\\Desktop\\SentimentAnalysis-master\\Website\\images")
png(file='graph.png')
barplot(total,main="All Movie Ratings",xlab="Movies Released this week", ylab="Ratings")
dev.off()

#browseURL("C:\Users\Ahmar Zafar\Desktop\SentimentAnalysis-master\Website\Website\index.html")
