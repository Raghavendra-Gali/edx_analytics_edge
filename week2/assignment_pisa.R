##############################################################################
# WEEK 2 - Linear Regression - PISA Assignment
#

# Uncomment to clear workspace on every run
rm(list=ls())

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week2")
pisaTrain = read.csv("pisa2009train.csv")
pisaTest = read.csv("pisa2009test.csv")
str(pisaTrain)
summary(pisaTrain)

# 1.2

tapply(pisaTrain$readingScore, pisaTrain$male, mean)

# 1.3
summary(pisaTrain) # Read off which terms have NAs in their summary

# 1.4 
pisaTrain = na.omit(pisaTrain)
pisaTest = na.omit(pisaTest)
str(pisaTrain)
str(pisaTest)

# 3.1
pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

lmScore= lm(readingScore ~ ., data=pisaTrain)
summary(lmScore)

# 3.2
SSE = sum(lmScore$residuals^2)
RMSE = sqrt(SSE/nrow(pisaTrain))

# 4.1 Predicting on test data
predTest = predict(lmScore, newdata = pisaTest)
predTestSummary = summary(predTest)
predRange = max(predTestSummary) - min(predTestSummary)

# 4.2
SSE = sum((pisaTest$readingScore - predTest)^2)
RMSE = sqrt(SSE / length(predTest))

# 4.3 
trainingMean = mean(pisaTrain$readingScore)
testSST = sum((pisaTest$readingScore - trainingMean)^2)

# 4.4
R2 = 1 - (SSE/testSST)