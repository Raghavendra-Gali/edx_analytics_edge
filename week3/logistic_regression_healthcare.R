##############################################################################
# WEEK 3 - Logistic Regression - Predicting Healthcare outcomes
#

# Use this package to split the dataset into training and testing
library("caTools")

# ROCR is used to plot ROC curves
library("ROCR")

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 4 : Logistic regression in R

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
quality = read.csv("quality.csv")
str(quality)

# Variable descriptions are below:

# MemberID numbers the patients from 1 to 131, and is just an identifying number.
# InpatientDays is the number of inpatient visits, or number of days the person spent in the hospital.
# ERVisits is the number of times the patient visited the emergency room.
# OfficeVisits is the number of times the patient visited any doctor's office.
# Narcotics is the number of prescriptions the patient had for narcotics.
# DaysSinceLastERVisit is the number of days between the patient's last emergency room visit and the end of the study period (set to the length of the study period if they never visited the ER). 
# Pain is the number of visits for which the patient complained about pain.
# TotalVisits is the total number of times the patient visited any healthcare provider.
# ProviderCount is the number of providers that served the patient.
# MedicalClaims is the number of days on which the patient had a medical claim.
# ClaimLines is the total number of medical claims.
# StartedOnCombination is whether or not the patient was started on a combination of drugs to treat their diabetes (TRUE or FALSE).
# AcuteDrugGapSmall is the fraction of acute drugs that were refilled quickly after the prescription ran out.
# PoorCare is the outcome or dependent variable, and is equal to 1 if the patient had poor care, and equal to 0 if the patient had good care.

table(quality$PoorCare)

# Baseline method in logistic regression is just to predict the more frequent
# case. So if we predicted poor care (98 out of 131 patients) the accuracy would
# be:
98/131

# This gives 75% accuracy we should beat this with the model !

# Need to split the data into a training and test set using caTools library
# Set seed to get predictable results
set.seed(88)
# 75 % of data used for training, 25% used for testing.
# caTools ensures 75% of patients receive good care in both training and testing
# This means the test and train data are balanced
split = sample.split(quality$PoorCare, SplitRatio = 0.75) 

# FALSE = testing data, TRUE = training data
split

# Create subsets using the split output
qualityTrain = subset(quality, split == TRUE)
qualityTest = subset(quality, split == FALSE)

nrow(qualityTrain)
nrow(qualityTest)

# Now create the logistic regression model, print out summary
QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial)
summary(QualityLog)

# Notice the positive betas on office visits and narcotics, increasing odds of
# y = 1 or poor care. AIC value is a measure of the quality of the model, and 
# is similar to R-squared in linear regression. Low AIC = good model.

# Tells the predict to give us probabilities
predictTrain = predict(QualityLog, type="response")
summary(predictTrain)

# Compute average prediction for each of the true outcomes (that are poor care)
tapply(predictTrain, qualityTrain$PoorCare, mean)

# Quick Question -  R, create a logistic regression model to predict "PoorCare" 
# using the independent variables "StartedOnCombination" and "ProviderCount"
QualityLog = glm(PoorCare ~ StartedOnCombination + ProviderCount, data=qualityTrain, family=binomial)
summary(QualityLog)

# VIDEO 5 : Thresholding

# Use a threshold value of 0.5. 
# Row labels are actual outcome, column labels are predicted outcome
t = 0.5
table(qualityTrain$PoorCare, predictTrain > t)

# Compute sensitivity and specificity
10/(10+15) # True positive rate (sensitivity) = 0.4
70/(70+4) # True negative rate (specificity) = 0.95

# Now re-run with a threshold of 0.7
t = 0.7
table(qualityTrain$PoorCare, predictTrain > t)
# Compute sensitivity and specificity
8/(8+17) # True positive rate (sensitivity) = 0.32
73/(73+1) # True negative rate (specificity) = 0.99

# Decrease threshold to 0.2. 
t = 0.2
table(qualityTrain$PoorCare, predictTrain > t)
# Compute sensitivity and specificity
16/(16+9) # True positive rate (sensitivity) = 0.64
54/(54+20) # True negative rate (specificity) = 0.73

# What value of t should we choose ?!

# VIDEO 5 : ROC Curve

# Plot an ROC curve with threshold values annotated
# ROCR takes (predictions from model, true outcomes of data).
ROCRpred = prediction(predictTrain, qualityTrain$PoorCare)
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# Quick Question

QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data=qualityTrain, family=binomial)
summary(QualityLog)

predictTest = predict(QualityLog, type="response", newdata=qualityTest)

ROCRpredTest = prediction(predictTest, qualityTest$PoorCare)

auc = as.numeric(performance(ROCRpredTest, "auc")@y.values)


