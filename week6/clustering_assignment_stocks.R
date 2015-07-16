##############################################################################
# WEEK 6 - Clustering - Assignment:  Stock return clustering
#

# Used to generate sample splits for training and test data
library(caTools)

# Used for normalization of the data before clustering
library(caret)

# Convert k-means clusters to kcca object using this library
library(flexclust)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# Read in the stocks dataframe
stocks = read.csv("StocksCluster.csv", stringsAsFactors = FALSE)
str(stocks)
summary(stocks)

# 1.2 Positive returns in Dec?
table(stocks$PositiveDec)
(6324)/(5256+6324)

# 1.3 check for correlations in the dataset
cor(stocks) > 0.19167279

# 1.4
stockSummary = summary(stocks)
stockSummary

# 2.1 Initial logistic regression
# Split the dataset into training and test sets
set.seed(144)
spl = sample.split(stocks$PositiveDec, SplitRatio = 0.7)
stocksTrain = subset(stocks, spl == TRUE)
stocksTest = subset(stocks, spl == FALSE)

# Train a logistic regression, calculate accuracy with 0.5 threshold
StocksModel = glm(PositiveDec ~ ., data = stocksTrain, family = binomial)
StocksPred = predict(StocksModel, type="response", newdata = stocksTrain)
table(stocksTrain$PositiveDec, StocksPred > 0.5)

# Test Set accuracy = 0.5711818
(990 + 3640) / nrow(stocksTrain)

# 2.2 Predict on test set
StocksPred = predict(StocksModel, type="response", newdata = stocksTest)
table(stocksTest$PositiveDec, StocksPred > 0.5)

# Test Set accuracy = 0.5670697
(417 + 1553) / nrow(stocksTest)

# 2.3 Test set baseline accuracy (0.5460564)
table(stocksTest$PositiveDec)
1897 / nrow(stocksTest)

# 3.1 Clustering stocks

# Remove the dependent variable from training and test data
limitedTrain = stocksTrain
limitedTrain$PositiveDec = NULL
limitedTest = stocksTest
limitedTest$PositiveDec = NULL

# 3.2 Pre-process the data before clustering
preproc = preProcess(limitedTrain)
normTrain = predict(preproc, limitedTrain)
normTest = predict(preproc, limitedTest)

summary(normTrain)

# 3.3 
mean(normTrain$ReturnJan)
mean(normTest$ReturnJan)

# 3.4 - K Means cluster with 3 clusters
set.seed(144)
k = 3
km = kmeans(normTrain, centers=k)
str(km)
table(km$cluster)

# 3.5 Clustering stock
km.kcca = as.kcca(km, normTrain)
clusterTrain = predict(km.kcca)
clusterTest = predict(km.kcca, newdata=normTest)

table(clusterTest)


# 4.1
stocksTrain1 = subset(stocksTrain, clusterTrain == 1)
stocksTrain2 = subset(stocksTrain, clusterTrain == 2)
stocksTrain3 = subset(stocksTrain, clusterTrain == 3)

stocksTest1 = subset(stocksTest, clusterTest == 1)
stocksTest2 = subset(stocksTest, clusterTest == 2)
stocksTest3 = subset(stocksTest, clusterTest == 3)

summary(stocksTrain1$PositiveDec)
summary(stocksTrain2$PositiveDec)
summary(stocksTrain3$PositiveDec)

# 4.2
StocksModel1 = glm(PositiveDec ~ ., data = stocksTrain1, family = binomial)
StocksModel2 = glm(PositiveDec ~ ., data = stocksTrain2, family = binomial)
StocksModel3 = glm(PositiveDec ~ ., data = stocksTrain3, family = binomial)

StocksModel1$coefficients
StocksModel2$coefficients
StocksModel3$coefficients

# 4.3
PredictTest1 = predict(StocksModel1, type="response", newdata = stocksTest1)
PredictTest2 = predict(StocksModel2, type="response", newdata = stocksTest2)
PredictTest3 = predict(StocksModel3, type="response", newdata = stocksTest3)

table(stocksTest1$PositiveDec, PredictTest1 > 0.5)
table(stocksTest2$PositiveDec, PredictTest2 > 0.5)
table(stocksTest3$PositiveDec, PredictTest3 > 0.5)

# now calculate accuracies
( 30  +774) / nrow(stocksTest1)
( 388 +757) / nrow(stocksTest2)
( 49  + 13) / nrow(stocksTest3)

# 4.4

AllPredictions = c(PredictTest1, PredictTest2, PredictTest3)
AllOutcomes = c(stocksTest1$PositiveDec, stocksTest2$PositiveDec, stocksTest3$PositiveDec)

table(AllOutcomes, AllPredictions > 0.5)
(467+1544)/(467+1110+353+1544)
