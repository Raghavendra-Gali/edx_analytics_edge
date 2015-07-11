##############################################################################
# WEEK 5 - Text Analytics - Recitation : Enron predictive coding
#

#tm is the text mapping library used for analytics
library(tm)

# SnowballC is also needed for NLP
library(SnowballC)

# caTools splits the data into training and test sets
library(caTools)

# CART-required libraries 
library(rpart)
library(rpart.plot)

# Load the ROC-curve related packages
library(ROCR)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week5")

# stringsAsFactors needs to be set to false to process natural text
emails = read.csv("energy_bids.csv", stringsAsFactors = FALSE)
str(emails)
summary(emails)

# 855 emails, with the text and responsive integer

# Let's check the first email. strwrap() wraps the string to make it easy to read
# This is discussing a paper on North American electricity, but doesn't relate
# to energy bids, so responsive is 0
strwrap(emails$email[1])
emails$responsive[1]

strwrap(emails$email[2])
emails$responsive[2]

# Check to see the distribution of responsive emails in the data set
table(emails$responsive)

# VIDEO 3 : PRE-PROCESSING

# Construct the corpus, check the first entry in it matches the one from above
corpus = Corpus(VectorSource((emails$email)))
strwrap(corpus[[1]])

# Preprocess using the tm library ..

# Convert to lower case
corpus = tm_map(corpus, tolower)

# (Need this extra step after converting to lower case)
corpus = tm_map(corpus, PlainTextDocument)

# Remove punctuation
corpus = tm_map(corpus, removePunctuation)

# Remove stopwords
corpus = tm_map(corpus, removeWords, stopwords("english"))

# Remove word endings (stem) the document
corpus = tm_map(corpus, stemDocument)

# now check the first email in the corpus to make sure the preprocessing worked
strwrap(corpus[[1]])

# VIDEO 4: BAG OF WORDS

# Now build a document term matrix for the document. There are 21735 terms from
# 855 documents. This is way too many variables for the amount of documents.
dtm = DocumentTermMatrix(corpus)
dtm


# Remove terms which appear in less than 3% of the documents. Now we have 788 
# terms from 855 documents, whichis much more reasonable
dtm = removeSparseTerms(dtm, 0.97)
dtm

# Now build a dataframe of the terms. First start by building a dataframe of the 
# frequencies of the 788 words which appear in each of the emails.
labelledTerms = as.data.frame(as.matrix(dtm))

# We also need to add the dependent variable (responsive)
labelledTerms$responsive = emails$responsive

# Now check how it looks. There are 789 terms, 788 are the frequencies of the
# words in the emails, and the 789th is whether the responsive bit is set. The
# amount of observations is the same (855 emails)
str(labelledTerms)

# VIDEO 5: BUILDING MODELS

# Now the data can be split into training/test data with 70% training data
set.seed(144)
spl = sample.split(labelledTerms$responsive, SplitRatio = 0.7)
train = subset(labelledTerms, spl == TRUE)
test = subset(labelledTerms, spl == FALSE)

# Check the amount of entries looks good
nrow(train)
nrow(test)

# Now build a simple CART model using default values.
emailCART = rpart(responsive ~ . , data = train, method="class")
# Jeff in the tree may be a reference to Jeff Skillings (CEO)
prp(emailCART)
pred = predict(emailCART, newdata = test)
pred.prob = pred

# Check the predictions. Prediction in 0 column is that is isn't responsive,
# column 1 is for responsive. Just select probability of 1 (Right column)
pred[1:10,]
pred.prob = pred[,2]

table(test$responsive, pred.prob > 0.5)

# Accuracy check = 0.8560311
(195+25)/(nrow(test))

# Baseline check = 0.8365759 
table(test$responsive)
215/nrow(test)

# If we review all positives by hand to check them, then a false positive leads
# to some extra unnecessary work. If it's a false negative, the email won't be 
# used at all. So we want to reduce false negatives at the cost of more false pos

# VIDEO 7 : THE ROC CURVE

predROCR = prediction(pred.prob, test$responsive)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)

# Analysis of the plot:
# We want to increase the true positive rate, even if it increases the false
# positive results as well. A threshold of around 0.04 give a TPR of ~70%, and
# FPR of ~20%, after which the graph slopes off.

# Check performance of the model = 0.7936323
performance(predROCR, "auc")@y.values

# VIDEO 8: PREDICTIVE CODING TODAY



