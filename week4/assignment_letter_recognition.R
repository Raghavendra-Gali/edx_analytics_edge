##############################################################################
# WEEK 4 - Trees - Assignment : Letter Recognition
#

#Libraries

# Calculate AUC with this library
library(ROCR)

# Use these libraries for the CART trees
library(rpart)
library(rpart.plot)

#Import random forest package for use in video 5
library(randomForest)

#Import packages for cross-validation (VIDEO 6)
library(caret)
library(e1071)


# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week4")
letters = read.csv("letters_ABPR.csv")
str(letters)
summary(letters)

# 1.1
letters$isB = as.factor(letters$letter == "B")

split = sample.split(letters$isB, SplitRatio = 0.5) 
lettersTrain = subset(letters, split == TRUE)
lettersTest = subset(letters, split == FALSE)

# Baseline accuracy = 0.754
table(lettersTest$isB)
(1175/(383+1175))

# 1.2 Uses a trick to treat everything apart from letter in the model.
# Accuracy is 
CARTb = rpart(isB ~ . - letter, data=lettersTrain, method="class")
CARTbPred = predict(CARTb, newdata = lettersTest, type="class")
table(lettersTest$isB, CARTbPred)
# Calculate accuracy
(1136+328)/(1136+39+55+328)

# 1.3 Build a random forest to predict if the letter is B.
# Don't use the letter or isB variables in forest.
# Accuracy is 0.9878049
set.seed(1000)
isBForest = randomForest(isB ~ . - letter - isB, data = lettersTrain)
PredictBForest = predict(isBForest, newdata = lettersTest)
table(lettersTest$isB, PredictBForest)
(1165+374) / (1165 + 10 + 9 + 374)

# 2.1 Multi-class prediction

# Need to convert the letter into a factor
letters$letter = as.factor( letters$letter)

# Create test and train sets using letter
set.seed(2000)
split = sample.split(letters$letter, SplitRatio = 0.5) 
lettersTrain = subset(letters, split == TRUE)
lettersTest = subset(letters, split == FALSE)

# Simple baseline = predict most frequent letter
table(lettersTest$letter)
401 / (395+383+401+379)

# 2.2 Classification tree. Accuracy is 0.8786906
CARTabpr = rpart(letter ~ . - isB, data=lettersTrain, method="class")
CARTabprPred = predict(CARTabpr, newdata = lettersTest, type="class")
table(lettersTest$letter, CARTabprPred)
(348+318+363+340)/nrow(lettersTest)

# 2.3 Random Forest. Accuracy is 0.9056483
set.seed(1000)
Forestabpr = randomForest(letter ~ . - isB, data=lettersTrain, method="class")
ForestabprPred = predict(Forestabpr, newdata = lettersTest, type="class")
table(lettersTest$letter, ForestabprPred)
(390+380+393+364)/nrow(lettersTest)

