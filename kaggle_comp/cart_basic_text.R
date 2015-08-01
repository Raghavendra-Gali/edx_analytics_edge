# KAGGLE COMPETITION - LOGISTIC REGRESSION W/TEXT (SIMPLE VERSION)

# Based on logistic_regression script, but using fewer variables to predict
# and pulling out the text of the reviews

# libraries
library(caTools)
library(ROCR)
library(tm)
library(SnowballC)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# We'll be doing NLP on the descriptions, so don't read strings as factors, and
# convert the actual factors back afterwards

ebay = read.csv("eBayiPadTrain.csv", stringsAsFactors = FALSE)
# eBayTest = read.csv("eBayiPadTest.csv")

# Clean up the factors and characters
head(ebay)
summary(ebay)
ebay$condition = as.factor(ebay$condition)
ebay$cellular = as.numeric(ebay$cellular)
ebay$carrier = as.factor(ebay$carrier)
ebay$color = as.factor(ebay$color)
ebay$storage = as.factor(ebay$storage)
ebay$productline = as.factor(ebay$productline)
str(ebay)

# Now do the text processing

# Prepare the corpus, including all pre-processing. Use entire data set to build corpus
corpus = Corpus(VectorSource(ebay$description))
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, PlainTextDocument)
# corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)
# Create Document Term Matrices for Title and Abstract, print out how many words
dtm = DocumentTermMatrix(corpus)
sparseDtm = removeSparseTerms(dtm, 0.99)
# Convert DTM to matrices
sparseDtmFrame = as.data.frame(as.matrix(sparseDtm))
# If some of the words begin with numbers, add a letter automatically so R can handle the columns.
colnames(sparseDtmFrame) = make.names(colnames(sparseDtmFrame))

# Now add in the dependent variable to the dataframe of words
sparseDtmFrame$sold = ebay$sold
sparseDtmFrame$biddable = ebay$biddable
sparseDtmFrame$startprice = ebay$startprice
# sparseDtmFrame$condition = ebay$condition
# sparseDtmFrame$cellular = ebay$cellular
# sparseDtmFrame$carrier = ebay$carrier
# sparseDtmFrame$color = ebay$color
# sparseDtmFrame$storage = ebay$storage
sparseDtmFrame$productline = ebay$productline
ebay= sparseDtmFrame

# Split the data with all variables into a training and test set
set.seed(123)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)



# Start with a simple CART model predicting based on all the independent vars
ebayCART = rpart(sold ~ . , data=ebayTrain, method="class")
prp(ebayCART)
# summary(ebayCART)

# And then make predictions on the test set:
PredTest = predict(ebayCART, newdata=ebayTest)

# Baseline accuracy = 0.5517751
table(ebayTest$sold)
300 / nrow(ebayTest)

PredTestClass = PredTest[,2] > 0.5

table(ebayTest$sold , PredTestClass)
(266 + 179) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest[,2], ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
#plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# Un-comment these lines to make the submission csv file
# MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)
# write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
