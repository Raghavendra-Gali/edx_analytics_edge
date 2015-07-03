##############################################################################
# WEEK 4 - Trees - Predicting Supreme Court decisions
#

# Use caTools to splitthe dataset into training and test sets
library(caTools)

# rpart is the library used for Recursive Partitioning and Regression Trees
# rpart.plot is used to generate plots from the model
library(rpart)
library(rpart.plot)

# Import the ROCR library to use ROC curves and AUC metric
library(ROCR)

#Import random forest package for use in video 5
library(randomForest)

#Import packages for cross-validation (VIDEO 6)
library(caret)
library(e1071)


# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 4: CART IN R

# First load in the dataset (stevens.csv)
# Reverse is the dependent variable - did Stevens vote to reverse decision
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week4")
stevens = read.csv("stevens.csv")
str(stevens)

# Create training and testing data sets. Use 70% of data for training
# balancing the dependent variable 'reverse'
set.seed(3000)
spl = sample.split(stevens$Reverse, SplitRatio = 0.7)
Train = subset(stevens, spl == TRUE)
Test = subset(stevens, spl == FALSE)

# Build the rpart model, same syntax as logistic models (glm function)
# but with method = "class" sets a classification tree instead of regression tree
# minbucket limits the tree to prevent overfitting
StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst,
                    data=Train, method = "class", minbucket = 25)

# Plot the tree (0 is affirm, 1 is reverse)
prp(StevensTree)

# Now use the model to predict the decisions
# The 'type' parameter effectively converts to a binary classifier
# using a threshold of 0.5
PredictCART = predict(StevensTree, newdata = Test, type="class")

# Check the confusion matrix - gives table below
table(Test$Reverse, PredictCART)

# PredictCART
# 0  1
# 0 41 36
# 1 22 71

# Accuracy = 66%
(42 + 71) / (42 + 35 + 22 + 71)

# Baseline accuracy = 55%
table(stevens$Reverse)
309 / (309 + 257)

# Generate an ROC curve to check thresholds.
# Need to re-generate the predictions without the type="class"
# argument, so it doesn't apply a threshold of 0.5
PredictROC = predict(StevensTree, newdata = Test)

# Print out ROCR results to interpret them. It gives 2 numbers:
# Probability of outcome 0, and prob of outcome 1 respectively 
# => Use the probabilities of the second column in ROC curve
PredictROC

# Predict using the second column of PredictROC, and check
# against dependent variable Test$Reverse
pred = prediction(PredictROC[,2], Test$Reverse)

#Calculate performance using the pred model, checking :
# tpr = True Positive Rate, fpr = False Positive Rate
perf = performance(pred, "tpr", "fpr")
plot(perf)

#QUICK QUESTION : Calculate the AUC of the model
as.numeric(performance(pred, "auc")@y.values)

#QUICK QUESTION : Recompute CART with minbucket = 5
StevensTreeMinBucket5 = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst,
                    data=Train, method = "class", minbucket = 5)
# Plot the tree
prp(StevensTreeMinBucket5)

#QUICK QUESTION : Recompute CART with minbucket = 100
StevensTreeMinBucket100 = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst,
                              data=Train, method = "class", minbucket = 100)
# Plot the tree
prp(StevensTreeMinBucket100)

# VIDEO 5 : RANDOM FORESTS

# Trees can also be used for regression, so convert dependent variable to 
# a factor to force a classification
Train$Reverse = as.factor(Train$Reverse)
Test$Reverse = as.factor(Test$Reverse)

# nodesize is similar to minbuckets in CART model, ntree is # trees to build
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, 
                             data = Train, nodesize = 25, ntree = 200)

PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)

# Calculate accuracy = 69% (CART was ~65%, log.reg. ~68%)
(43 + 74) / (43 + 34 + 19 + 74)

# QUICK QUESTION : Random seeds

set.seed(100)
# nodesize is similar to minbuckets in CART model, ntree is # trees to build
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, 
                             data = Train, nodesize = 25, ntree = 200)

PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)

# Accuracy 
(43 + 74) / (43 + 34 + 19 + 74)

set.seed(200)
# nodesize is similar to minbuckets in CART model, ntree is # trees to build
StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, 
                             data = Train, nodesize = 25, ntree = 200)

PredictForest = predict(StevensForest, newdata = Test)
table(Test$Reverse, PredictForest)

# Accuracy 
(44 + 76) / (44 + 33 + 17 + 76)

# VIDEO 6 : CROSS-VALIDATION

# trainControl 'cv' method is for cross-validation, number is # folds
# the cpGrid seq(--) generates a vector from 0.01 to 0.5 in steps of 0.01
numFolds = trainControl(method="cv",number=10)
cpGrid = expand.grid(.cp=seq(0.01,0.5,0.01))

# Now perform actual cross-validation
train(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst,
      data=Train, method="rpart", trControl=numFolds, tuneGrid=cpGrid)

# This identified the cp value of 0.19 as giving the maximum accuracy.
# Now re-run the CART using this instead of minbuckets, set to classification
StevensTreeCV = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst, 
                      data = Train, method = "class", cp = 0.19)

PredictCV = predict(StevensTreeCV, newdata = Test, type = "class")
table(Test$Reverse, PredictCV)

# Calculate the accuracy = 0.72. Previous CART was 0.69.
(59 + 64) / (59 + 18 + 29 + 64)
prp(StevensTreeCV)


