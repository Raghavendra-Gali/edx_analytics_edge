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
# ebaySub = read.csv("eBayiPadTest.csv")

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
sparseDtmFrame$productline = ebay$productline
ebay = sparseDtmFrame

# Split the data with all variables into a training and test set
set.seed(123)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)

# We will just create a simple logistic regression model.
# Predict using everything but Unique ID and text
FirstLogRegModel = glm(sold ~ . , data=ebayTrain, family=binomial)
summary(FirstLogRegModel)

# And then make predictions on the test set:
PredTest = predict(FirstLogRegModel, newdata=ebayTest, type="response")

# Baseline accuracy = 0.5376344
table(ebayTest$sold)
300 / nrow(ebayTest)


table(ebayTest$sold , PredTest > 0.5)
(234 + 191) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

####################
# Submission code

sparseDtmFrame = as.data.frame(as.matrix(sparseDtm))
# If some of the words begin with numbers, add a letter automatically so R can handle the columns.
colnames(sparseDtmFrame) = make.names(colnames(sparseDtmFrame))

# Now add in the dependent variable to the dataframe of words
sparseDtmFrame$sold = ebay$sold
sparseDtmFrame$biddable = ebay$biddable
sparseDtmFrame$startprice = ebay$startprice
sparseDtmFrame$productline = ebay$productline
ebay= sparseDtmFrame


eBaySubmission = read.csv("eBayiPadTest.csv")
# And then make predictions on the test set:
PredTest = predict(FirstLogRegModel, newdata=eBaySubmission, type="response")

MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)
write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
