# KAGGLE COMPETITION - LOGISTIC REGRESSION (SIMPLE VERSION)

# Based on logistic_regression script, but using fewer variables to predict


# libraries
library(caTools)
library(ROCR)

library(rpart)
library(rpart.plot)


source ("data_preprocess.R")

# Split the data with all variables into a training and test set
# set.seed(123)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)

# Start with a simple CART model predicting based on all the independent vars
ebayCART = rpart(sold ~ biddable + startprice + condition + cellular + 
                   carrier + color + storage + productline, data=ebayTrain, method="class")
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
