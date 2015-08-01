# KAGGLE COMPETITION - RANDOM FOREST SIMPLE VERSION

# libraries
library(caTools)
library(ROCR)

library(randomForest)


source("data_preprocess.R")

# Combine text features into the train/test and submission datasets
ebayTextFeatures$biddable = ebay$biddable
ebayTextFeatures$discount = ebay$discount
ebayTextFeatures$discounted = ebay$discounted
ebayTextFeatures$productline = ebay$productline
ebayTextFeatures$sold = ebay$sold
ebay = ebayTextFeatures

ebaySubTextFeatures$UniqueID = ebaySub$UniqueID
ebaySubTextFeatures$biddable = ebaySub$biddable
ebaySubTextFeatures$discount = ebaySub$discount
ebaySubTextFeatures$discounted = ebaySub$discounted
ebaySubTextFeatures$productline = ebaySub$productline
ebaySub = ebaySubTextFeatures


# Split the data with all variables into a training and test set
# set.seed(12)
split = sample.split(ebay$sold, SplitRatio = 0.7)
ebayTrain = subset(ebay, split == TRUE)
ebayTest = subset(ebay, split == FALSE)

str(ebayTest)
str(ebayTrain)


# Create random forest (all un-needed independent vars removed already)
ebayForest = randomForest(sold ~ ., data=ebayTrain)

# And then make predictions on the test set:
PredTest = predict(ebayForest, newdata=ebayTest)

# Baseline accuracy = 0.5517751
table(ebayTest$sold)
300 / nrow(ebayTest)

PredTestClass = PredTest > 0.5

# Accuracy of model
table(ebayTest$sold , PredTestClass)
(261 + 186) / nrow(ebayTest)

# Compute the accuracy on the test set
ROCRpred = prediction(PredTest, ebayTest$sold)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# Un-comment these lines to make the submission csv file
PredSub = predict(ebayForest, newdata=ebaySub)
MySubmission = data.frame(UniqueID = ebaySub$UniqueID, Probability1 = PredSub)
write.csv(MySubmission, "forest_basic_text_submission.csv", row.names=FALSE)


