# KAGGLE COMPETITION - LOGISTIC REGRESSION (SIMPLE VERSION)

# Based on logistic_regression script, but using fewer variables to predict


# libraries
library(caTools)
library(ROCR)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# As this is logistic regression-only, read in strings as factors. Not planning any text analysis (yet)
# So no stringsAsFactors=FALSE
# The eBayTest doesn't have the dependent variable in it, so we can't evaluate AUC on it :-(
ebay = read.csv("eBayiPadTrain.csv")
# eBayTest = read.csv("eBayiPadTest.csv")

# Split the data with all variables into a training and test set
set.seed(12)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)

# We will just create a simple logistic regression model.
# Predict using everything but Unique ID and text
FirstLogRegModel = glm(sold ~ biddable + startprice + productline, 
                      data=ebayTrain, family=binomial)

summary(FirstLogRegModel)

# And then make predictions on the test set:
PredTest = predict(FirstLogRegModel, newdata=ebayTest, type="response")

# Baseline accuracy = 0.5517751
table(ebayTest$sold)
300 / nrow(ebayTest)

# Model accuracy
table(ebayTest$sold , PredTest > 0.5)
(252 + 186) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))



# Un-comment these lines to make the submission csv file
# 
# ebaySub = read.csv("eBayiPadTest.csv")
# PredTest = predict(FirstLogRegModel, newdata=ebaySub, type="response")
# MySubmission = data.frame(UniqueID = ebaySub$UniqueID, Probability1 = PredTest)
# write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
