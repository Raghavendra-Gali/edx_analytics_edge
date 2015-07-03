##############################################################################
# WEEK 4 - Trees - Assignment : Predicting earnings from Census data
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
census = read.csv("census.csv")
str(census)
summary(census)

# 1.1 Build logistic regression model to predict over50k variable

set.seed(2000)
split = sample.split(census$over50k, SplitRatio = 0.6)
censusTrain = subset(census, split == TRUE)
censusTest = subset(census, split == FALSE)

censusLogReg = glm(over50k ~ . , data=censusTrain, family=binomial)
summary(censusLogReg)
predictTest = predict(censusLogReg, type="response", newdata = censusTest)
table(censusTest$over50k, predictTest > 0.5)

# model accuracy with threshold of 0.5 = 0.8552107
(9051+1888) / (9051+662+1190+1888)

# baseline accuracy
table(censusTest$over50k)
9713/(9713+3078)

# 1.4

# Check the AUC of the model = 0.9061598

ROCRpred = prediction(predictTest, censusTest$over50k)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Bonus - plot the ROC curve too. 
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# 2.1 - CART model, accuracy = 0.8473927

CART = rpart(over50k ~ . , data=censusTrain, method="class")
prp(CART)
CARTPred = predict(CART, newdata = censusTest, type="class")
table(censusTest$over50k, CARTPred)

# Accuracy
(9243+1596)/nrow(censusTest)

# 2.5 Redo CART model using probabilities, and not classification
# This gives a 2-column matrix, we need column 2 which is 'over50k' probability
CARTPredNoClass = predict(CART, newdata = censusTest)
# CARTPredNoClass[,2]

# AUC is 0.8470256
ROCRpred = prediction(CARTPredNoClass[,2], censusTest$over50k)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Bonus - plot the ROC curve too. 
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# 3.1 - Random Forest

# Select 2000 examples to train on
set.seed(1)
trainSmall = censusTrain[sample(nrow(censusTrain), 2000), ]

set.seed(1)
censusForest = randomForest(over50k ~ . , data=trainSmall, method="class")
censusForestPred = predict(censusForest, newdata = censusTest)
table(censusTest$over50k, censusForestPred)
(9613+1053)/nrow(censusTest)

# 3.2 Plot the number of times, aggregated over all trees, that a certain 
# variable is selected for a split
vu = varUsed(censusForest, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(censusForest$forest$xlevels[vusorted$ix]))

# 3.3 Impurity of the random forest ..?
varImpPlot(censusForest)

# 4.1 - Selecting CP using cross-validation

set.seed(2)
numFolds = trainControl(method="cv",number=10)
cartGrid = expand.grid( .cp = seq(0.002,0.1,0.002))

# Now perform actual cross-validation 0.002
train(over50k ~ . , data=censusTrain, method="rpart", trControl=numFolds, tuneGrid=cartGrid)

# 4.2 With cross-validation cp, prediction accuracy is 0.8612
CARTcp = rpart(over50k ~ . , data=censusTrain, method="class", cp = 0.002)
CARTcpPred = predict(CARTcp, newdata = censusTest, type="class")
table(censusTest$over50k, CARTcpPred)
(9178+1838)/nrow(censusTest)

# 4.3
prp(CARTcp)
