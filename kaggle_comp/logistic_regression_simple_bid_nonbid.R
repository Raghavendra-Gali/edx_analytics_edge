# KAGGLE COMPETITION - LOGISTIC REGRESSION BID VS NON-BID

# Split the dataset into biddable and non-biddable datasets, train separately

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
ebayBiddable = subset(ebay, biddable == TRUE)
ebayNonBiddable = subset(ebay, biddable == FALSE)
  # eBayTest = read.csv("eBayiPadTest.csv")

str(ebay)
str(ebayNonBiddable)
str(ebayBiddable)

# Split the data with all variables into a training and test set
set.seed(12)
splitBiddable = sample.split(ebayBiddable$sold, SplitRatio = 0.7)
ebayBiddableTrain = subset(ebayBiddable, splitBiddable == TRUE)
ebayBiddableTest = subset(ebayBiddable, splitBiddable == FALSE)

splitNonBiddable = sample.split(ebayNonBiddable$sold, SplitRatio = 0.7)
ebayNonBiddableTrain = subset(ebayNonBiddable, splitNonBiddable == TRUE)
ebayNonBiddableTest = subset(ebayNonBiddable, splitNonBiddable == FALSE)

str(ebayBiddableTrain)
str(ebayBiddableTest)
str(ebayNonBiddableTrain)
str(ebayNonBiddableTest)

# Create separate logistic regressions using different variables for each
biddableLogReg= glm(sold ~ startprice + condition + storage + productline, data=ebayBiddableTrain, family=binomial)
NonBiddableLogReg = glm(sold ~ startprice + productline,  data=ebayNonBiddableTrain, family=binomial)

summary(biddableLogReg)
summary(NonBiddableLogReg)

# And then make predictions on the test set:
PredBiddableTest = predict(biddableLogReg, newdata=ebayBiddableTest, type="response")
PredNonBiddableTest = predict(NonBiddableLogReg, newdata = ebayNonBiddableTest, type="response")

# Baseline accuracy = 0.5376344
table(ebayNonBiddableTest$sold)
table(ebayBiddableTest$sold)
300 / (300+258)

PredTest = c(PredBiddableTest, PredNonBiddableTest)
ebayTest = rbind(ebayBiddableTest, ebayNonBiddableTest)

str(PredTest)
str(ebayTest)

table(ebayTest$sold , PredTest > 0.5)
(274 + 176) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))



# Un-comment these lines to make the submission csv file
ebaySub = read.csv("eBayiPadTest.csv")

ebaySubBiddable = subset(ebaySub, biddable == TRUE)
ebaySubNonBiddable = subset(ebaySub, biddable == FALSE)

PredSubBiddableTest = predict(biddableLogReg, newdata=ebaySubBiddable, type="response")
PredSubNonBiddableTest = predict(NonBiddableLogReg, newdata = ebaySubNonBiddable, type="response")

# Merge back into dataframe to order by Unique ID
ebaySubBiddable$prediction = PredSubBiddableTest
ebaySubNonBiddable$prediction = PredSubNonBiddableTest

ebaySub = rbind(ebaySubBiddable, ebaySubNonBiddable)
ebaySub = ebaySub[order(ebaySub$UniqueID),]

# Remember to sort by Unique ID !!!

MySubmission = data.frame(UniqueID = ebaySub$UniqueID, Probability1 = ebaySub$prediction)
write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
