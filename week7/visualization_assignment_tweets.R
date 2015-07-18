# VISUALIZATION - Assignment : Tweets

#tm is the text mapping library used for analytics
library(tm)

# wordcloud visualization
library(wordcloud)

# RColorBrewer is a library with pre-defined palettes
library(RColorBrewer)

# Change into the directory and load data
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

tweets = read.csv("tweets.csv")
# There are 1181 tweets, with a Tweet (text of the tweet), and Avg (rating of the tweet)
str(tweets)

# 1.1 Prepare the corpus, convert to lowercase, remove punctuation, remove stopwords, build DTM, convert to dataframe

# Prepare the corpus, don't stem words or remove sparse items
corpus = Corpus(VectorSource(tweets$Tweet))
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))

# Create Document Term Matrix and convert back to a dataframe
frequencies = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(frequencies))

# 2.1

# There are 1181 observations of 3780 words.
# The words are on the column names
str(allTweets)
rownames(allTweets)
colnames(allTweets) # List of words

# 2.2 Find frequency of words across all tweets
str(colSums(allTweets))

# 2.3  (takes a long time to plot the word cloud, don't do this now)
# wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25))

# 2.4 Rebuild the corpus, drop apple from the cloud
# Prepare the corpus, don't stem words or remove sparse items
corpus = Corpus(VectorSource(tweets$Tweet))
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, c(stopwords("english"), "apple"))

# Create Document Term Matrix and convert back to a dataframe
frequencies = DocumentTermMatrix(corpus)
allTweets = as.data.frame(as.matrix(frequencies))

# wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25))

# 3.1 Plot 4 different ways

# Negative tweets
allTweets$Avg = tweets$Avg
negativeTweets = subset(allTweets, Avg <= -1)
# wordcloud(colnames(negativeTweets), colSums(negativeTweets), scale=c(2, 0.25))

# non-random order
# wordcloud(colnames(allTweets), colSums(allTweets), scale=c(2, 0.25), random.color = TRUE)

# 4.1 Color palette

# Display all the colors available
display.brewer.all()

# 4.3 
display.brewer.pal(9, "Blues")
display.brewer.pal(9, "Blues")[c(-5, -6, -7, -8, -9)]
brewer.pal(9, "Blues")[c(-1, -2, -3, -4)]
brewer.pal(9, "Blues")[c(5, 6, 7, 8, 9)]
