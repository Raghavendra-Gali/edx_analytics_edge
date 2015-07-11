##############################################################################
# WEEK 5 - Text Analytics - Video : Tweets
#

#tm is the text mapping library used for analytics
library(tm)

# SnowballC is also needed for NLP
library(SnowballC)

# caTools used for the sampel.split() function 
library(caTools)

# libraries required for CART modelling and plot
library(rpart)
library(rpart.plot)

# Library used for random forest
library(randomForest)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week5")

# stringsAsFactors needs to be set to false to process natural text
tweets = read.csv("tweets.csv", stringsAsFactors = FALSE)
str(tweets)
summary(tweets)

# 1181 tweets, 2 observations each for the tweet text, and Avg sentiment
# hist(tweets$Avg)

# the Negative section will be set to true if the average sentiment is <= -1
# Use the as.factor to convert to categorical data
tweets$NegativeNoFactor = (tweets$Avg <= -1)
tweets$Negative = as.factor(tweets$Avg <= -1)
summary(tweets$Negative)

# Need to convert the tweets to a corpus before processing
corpus = Corpus(VectorSource(tweets$Tweet))
corpus

# This should show the first tweet in the corpus as a sanity check
corpus[[1]]$content

# Map the corpus to lowercase words ...
corpus = tm_map(corpus, tolower)
# Extra requirement from the Important Note section above. It converts all the 
# documents in the corpus to plan text documents.
corpus = tm_map(corpus, PlainTextDocument)
# Check the first tweet has changed to lower-case.
corpus[[1]]

# Remove punctuation ...
corpus = tm_map(corpus, removePunctuation)
# Check the first tweet has punctuation removed.
corpus[[1]]

# Remove stop words and 'apple'  ...
stopwords("english")[1:10]
corpus = tm_map(corpus, removeWords, c("apple", stopwords("english")))
# Check the first tweet has punctuation removed.
corpus[[1]]

# Now stem the document, removing endings of words
corpus = tm_map(corpus, stemDocument)
# Check the first tweet has punctuation removed.
corpus[[1]]

# VIDEO 6 : BAG OF WORDS IN R

# Now need to extract the amount of terms in the tweets into a matrix
frequencies = DocumentTermMatrix(corpus)
frequencies
# 3289 words in the matrix, 1181 documents

# Use the inspect function to check how documents 1000 to 1005 look 
# with terms 505 to 515. There are many 0s in the matrix (known as sparse)
inspect(frequencies[1000:1005, 505:515])

# Find frequency terms in the matrix, which appear at least 20 times in the corpus.
# There are only 56 terms ! This is bad because there are a lot of useless terms:
# 1. Computational time to process a huge number of independent variables
# 2. The ratio of independent variables to labelled examples can give a poor model
findFreqTerms(frequencies, lowfreq = 20)

# Remove the sparse terms, only keeping those that appear in 99.5% or more of the tweets
sparse = removeSparseTerms(frequencies, 0.995)
sparse

# now convert the sparse matrix into a dataframe
tweetsSparse = as.data.frame(as.matrix(sparse))

# Now a lot of the variable names will start with numbers (which came from the)
# Twitter corpus), add a letter on the front where necessary
colnames(tweetsSparse) = make.names(colnames(tweetsSparse))

# Add in the Negative field from the original variable to the sparse one
tweetsSparse$Negative = tweets$Negative

# now split into training (70% of data) and test sets 
set.seed(123)
split = sample.split(tweetsSparse$Negative, SplitRatio = 0.7)
trainSparse = subset(tweetsSparse, split == TRUE)
testSparse = subset(tweetsSparse, split == FALSE)

# QUICK QUESTION : Which words appear at least 100 times?
# Redo the frequent terms search with 100 as the cutoff
findFreqTerms(frequencies, lowfreq = 100)

# VIDEO 7 : Predicting sentiment

# CART
# First use CART  to create a predictive model. 
# method = "class" makes it generate a classification model.
# Default settings, no minbucket or cp.
tweetCART = rpart(Negative ~ . , data = trainSparse, method="class")
prp(tweetCART)

# type = class makes it return classification predictions
predictCART = predict(tweetCART, newdata = testSparse, type="class")
table(testSparse$Negative, predictCART)
# Calculate accuracy = 0.87887
(294+18)  / (294 + 6 + 37 + 18)

# BASELINE 
# Now compare this to a simple baseline (always predicting common case)
# In the test set, 300 FALSE, 55 TRUE. Accuracy is 0.8451
table(testSparse$Negative)
300 / nrow(testSparse)

# RANDOM FOREST

# set the seed and build random forests (no class parameter here)
# There are ~300 independent variables which takes a long time to build
set.seed(123)
tweetRF = randomForest(Negative ~ . , data = trainSparse)

# Now predict using the model
predictRF = predict(tweetRF, newdata = testSparse)
table(testSparse$Negative, predictRF)
# Check the accuracy = 0.8845
(293+21)/nrow(testSparse)

# QUICK QUESTION : Evaluate Logistic regression accuracy
tweetLog = glm(Negative ~ . , data = trainSparse, family="binomial")
predictions = predict(tweetLog, newdata=testSparse, type="response")
table(testSparse$Negative, predictions > 0.5)
# Accuracy
(253 + 32)/nrow(testSparse)


