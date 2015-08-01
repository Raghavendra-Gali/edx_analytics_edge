# KAGGLE COMPETITION - LOGISTIC REGRESSION

# Aim is to use logistic regression with careful choice of independent variables


# libraries
library(caTools)
library(ROCR)

source("data_preprocess.R")

# Split the data with all variables into a training and test set
set.seed(123)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)

# We will just create a simple logistic regression model.
# Predict using everything but Unique ID and text
FirstLogRegModel = glm(sold ~ biddable + startprice + condition + cellular + 
                      carrier + color + storage + productline + discount, 
                      data=ebayTrain, family=binomial)

summary(FirstLogRegModel)

# And then make predictions on the test set:
PredTest = predict(FirstLogRegModel, newdata=ebayTest, type="response")

# Baseline accuracy = 0.5376344
table(ebayTest$sold)
300 / nrow(ebayTest)

# Model accuracy
table(ebayTest$sold , PredTest > 0.5)
(246 + 189) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# Un-comment these lines to make the submission csv file
# MySubmission = data.frame(UniqueID = eBayTest$UniqueID, Probability1 = PredTest)
# write.csv(MySubmission, "SubmissionSimpleLog.csv", row.names=FALSE)
