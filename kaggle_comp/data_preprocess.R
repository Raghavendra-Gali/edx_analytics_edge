# KAGGLE COMPETITION - DATA PRE-PROCESSING

# Try using mice library to impute missing values
library(mice)
library(tm)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# As this is logistic regression-only, read in strings as factors. Not planning any text analysis (yet)
# So no stringsAsFactors=FALSE
# The eBayTest doesn't have the dependent variable in it, so we can't evaluate AUC on it :-(
ebay = read.csv("eBayiPadTrainPrices.csv")
ebaySub = read.csv("eBayIpadTestPrices.csv")
str(ebay)
summary(ebay)


# Pre-process storage : Change the storage factor into an integer.
# replace unknown values with the median (16)
summary(ebay$storage)
storageMedianIndex = median(as.numeric(ebay$storage))
storageMedian = ebay$storage[storageMedianIndex]
ebay$storage[ebay$storage == "Unknown"] = storageMedian
ebay$storageInteger = as.integer(as.character(ebay$storage))
summary(as.factor(ebay$storageInteger))

summary(ebaySub$storage)
storageMedianIndex = median(as.numeric(ebaySub$storage))
storageMedian = ebaySub$storage[storageMedianIndex]
ebaySub$storage[ebaySub$storage == "Unknown"] = storageMedian
ebaySub$storageInteger = as.integer(as.character(ebaySub$storage))
summary(as.factor(ebaySub$storageInteger))



# Process the price : Use retailprice and startprice to set difference 
#                     this is effectively the discount

ebay$discount = ebay$retailprice - ebay$startprice
ebay$discount[is.na(ebay$discount)] = 0
ebaySub$discount = ebaySub$retailprice - ebaySub$startprice
ebay$discount[is.na(ebay$discount)] = 0

ebay$discounted = ebay$discount > 0
ebaySub$discounted = ebaySub$discount > 0

# Process the productline : Some are wrong in training data
ebay$productline[ebay$productline == "iPad 5"] = "iPad Air"
ebay$productline[ebay$productline == "iPad mini Retina"] = "iPad mini 2"
ebay$productline = droplevels(ebay$productline)
table(ebay$productline)
table(ebaySub$productline)

# Try taking the log of the storage
ebay$logStorage = log(ebay$storageInteger)
ebaySub$logStorage = log(ebaySub$storageInteger)

# Copy the text analytics from the example script

# We are adding in the argument stringsAsFactors=FALSE, since we have some text fields
eBayTrain = read.csv("eBayiPadTrain.csv", stringsAsFactors=FALSE)
eBayTest = read.csv("eBayiPadTest.csv", stringsAsFactors=FALSE)

# Then create a corpus from the description variable. You can use other variables in the dataset for text analytics, but we will just show you how to use this particular variable. 
# Note that we are creating a corpus out of the training and testing data.

CorpusDescription = Corpus(VectorSource(c(eBayTrain$description, eBayTest$description)))
CorpusDescription = tm_map(CorpusDescription, content_transformer(tolower), lazy=TRUE)
CorpusDescription = tm_map(CorpusDescription, PlainTextDocument, lazy=TRUE)
CorpusDescription = tm_map(CorpusDescription, removePunctuation, lazy=TRUE)
CorpusDescription = tm_map(CorpusDescription, removeWords, stopwords("english"), lazy=TRUE)
CorpusDescription = tm_map(CorpusDescription, stemDocument, lazy=TRUE)

# Now we are ready to convert our corpus to a DocumentTermMatrix, remove sparse terms, and turn it into a data frame. 
# We selected one particular threshold to remove sparse terms, but remember that you can try different numbers!
dtm = DocumentTermMatrix(CorpusDescription)
sparse = removeSparseTerms(dtm, 0.95)
DescriptionWords = as.data.frame(as.matrix(sparse))

# Let's make sure our variable names are okay for R:
colnames(DescriptionWords) = make.names(colnames(DescriptionWords))

# Now we need to split the observations back into the training set and testing set.
# To do this, we can use the head and tail functions in R. 
# The head function takes the first "n" rows of DescriptionWords (the first argument to the head function), where "n" is specified by the second argument to the head function. 
# So here we are taking the first nrow(eBayTrain) observations from DescriptionWords, and putting them in a new data frame called "DescriptionWordsTrain"

DescriptionWordsTrain = head(DescriptionWords, nrow(eBayTrain))

# The tail function takes the last "n" rows of DescriptionWords (the first argument to the tail function), where "n" is specified by the second argument to the tail function. 
# So here we are taking the last nrow(eBayTest) observations from DescriptionWords, and putting them in a new data frame called "DescriptionWordsTest"

DescriptionWordsTest = tail(DescriptionWords, nrow(eBayTest))

# Note that this split of DescriptionWords works to properly put the observations back into the training and testing sets, because of how we combined them together when we first made our corpus.

# Before building models, we want to add back the original variables from our datasets. We'll add back the dependent variable to the training set, and the WordCount variable to both datasets. You might want to add back more variables to use in your model - we'll leave this up to you!

DescriptionWordsTrain$WordCount = eBayTrain$WordCount
DescriptionWordsTest$WordCount = eBayTest$WordCount


# Fold the features from NLP into the original dataframes
ebayTextFeatures = DescriptionWordsTrain
ebaySubTextFeatures = DescriptionWordsTest

# Remember that you can always look at the structure of these data frames to understand what we have created


# Now let's create a logistic regression model using all of the variables:

# DescriptionWordsLog = glm(sold ~ ., data=DescriptionWordsTrain, family=binomial)

# And make predictions on our test set:

# PredTest = predict(DescriptionWordsLog, newdata=DescriptionWordsTest, type="response")

# Now we can prepare our submission file for Kaggle:

# MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)

# write.csv(MySubmission, "SubmissionDescriptionLog.csv", row.names=FALSE)

# You should upload the submission "SubmissionDescriptionLog.csv" on the Kaggle website to use this as a submission to the competition

# This script file was just designed to help you get started - to do well in the competition, you will need to build better models!
