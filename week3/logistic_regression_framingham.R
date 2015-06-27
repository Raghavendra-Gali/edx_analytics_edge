##############################################################################
# WEEK 3 - Logistic Regression - Framingham Heart Study
#

# Use this package to split the dataset into training and testing
library("caTools")

# ROCR is used to plot ROC curves
library("ROCR")

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 3: A LOGISTIC REGRESSION MODEL

# First load in the dataset
# TenYearCHD is the dependent variable
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
framingham = read.csv("framingham.csv")
str(framingham)

# Split the dataset into a training and test set using caTools
# Want 65% of the data in the training set. With a lot of observations
# like we have (4240) you can afford to hold more data back for testing.
set.seed(1000)
split = sample.split(framingham$TenYearCHD, SplitRatio = 0.65)

# Split the dataset using the booleans created by the split command above
train = subset(framingham, split == TRUE)
test = subset(framingham, split == FALSE)

# Build the Logistic regression model. Use a shorthand '.' to select all 
# the independent variables for use in the model
framinghamLog = glm(TenYearCHD ~ . , data = train, family = binomial)
summary(framinghamLog)

# The summary shows male, age, prevalentStroke, totChol, sysBP and glucose
# are statistically significant variables. Their coefficient is +ve, meaning
# they *increase* the probability of 10-year CHD.

# Make predictions, try a threshold value of 0.5
predictTest = predict(framinghamLog, type="response", newdata = test)
table(test$TenYearCHD, predictTest > 0.5)

# Calculate accuracy (TP and TN over all predictions) - about 85%
(1069 + 11) / (1069 + 6 + 187 + 11)

# What is the baseline (guess the most common case)? - about 84%
(1069 + 6) / (1069 + 6 + 187 + 11)

# Calculate AUC to evaluate which threshold to use. We get ~74
ROCRpred = prediction(predictTest, test$TenYearCHD)
as.numeric(performance(ROCRpred, "auc")@y.values)

# QUICK QUESTION

# Sensitivity = TP / (TP + FN)
11 / (11 + 187)

# Specificity = TN / (TN + FP)
1069 / (1069 + 6)

# VIDEO 4: VALIDATING THE MODEL

# Need to test on other populations outside of Framingham model



