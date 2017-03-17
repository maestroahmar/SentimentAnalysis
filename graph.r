movie_raw <- as.matrix(read.table("ratings.txt",sep='\n',header=F,col.names=c('raw_rate')))
movie_raw <- movie_raw[order(-movie_raw)]

