# KAGGLE COMPETITION - RANDOM FOREST SIMPLE VERSION

# libraries
library(caTools)
library(ROCR)

library(randomForest)


# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# As this is logistic regression-only, read in strings as factors. Not planning any text analysis (yet)
# So no stringsAsFactors=FALSE
# The eBayTest doesn't have the dependent variable in it, so we can't evaluate AUC on it :-(
ebay = read.csv("eBayiPadTrain.csv")
# eBayTest = read.csv("eBayiPadTest.csv")

# Split the data with all variables into a training and test set
set.seed(123)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)

# Start with a simple CART model predicting based on all the independent vars
ebayForest = rpart(sold ~ biddable + startprice + condition + cellular + 
                   carrier + color + storage + productline, data=ebayTrain)

# And then make predictions on the test set:
PredTest = predict(ebayForest, newdata=ebayTest)

# Baseline accuracy = 0.5517751
table(ebayTest$sold)
300 / nrow(ebayTest)

PredTestClass = PredTest > 0.5

# Accuracy of model
table(ebayTest$sold , PredTestClass)
(274 + 173) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))


# Un-comment these lines to make the submission csv file
# MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)
# write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
