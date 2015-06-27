##############################################################################
# WEEK 3 - Logistic Regression - Assignment - Parole violators
#

# Use caTools in problem 3.1 to split data into training and test data
library(caTools)

# ROCR is used to plot ROC curves
library("ROCR")

# Uncomment to clear workspace on every run
rm(list=ls())

# male: 1 if the parolee is male, 0 if female
# race: 1 if the parolee is white, 2 otherwise
# age: the parolee's age (in years) when he or she was released from prison
# state: a code for the parolee's state. 2 is Kentucky, 3 is Louisiana, 4 is Virginia, and 1 is any other state. The three states were selected due to having a high representation in the dataset.
# time.served: the number of months the parolee served in prison (limited by the inclusion criteria to not exceed 6 months).
# max.sentence: the maximum sentence length for all charges, in months (limited by the inclusion criteria to not exceed 18 months).
# multiple.offenses: 1 if the parolee was incarcerated for multiple offenses, 0 otherwise.
# crime: a code for the parolee's main crime leading to incarceration. 2 is larceny, 3 is drug-related crime, 4 is driving-related crime, and 1 is any other crime.
# violator: 1 if the parolee violated the parole, and 0 if the parolee completed the parole without violation.


setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
parole = read.csv("parole.csv")
str(parole)

paroleViolators = subset(parole, violator == 1)
str(paroleViolators)
summary(paroleViolators)

# Q2.2 state and crime are unordered factors with at least 3 levels
# Convert them to factors using the as.factor() function
summary(parole)
table(parole$state)
parole$state = as.factor(parole$state)
parole$crime = as.factor(parole$crime)
summary(parole)

# Q3.1

set.seed(144)
split = sample.split(parole$violator, SplitRatio = 0.7)
train = subset(parole, split == TRUE)
test = subset(parole, split == FALSE)


# Q4.1

model1 = glm(violator ~ ., data=train, family = "binomial")
summary(model1)

# Q4.3
logit = -4.2411574 + 0.3869904 + 0.8867192 + (50 * -0.0001756) + (3 * -0.1238867) + (12 * 0.0802954) + 0.6837143
odds = exp(logit)
prob = 1 / (1 + exp(-logit))

# Q5.1
predictTest = predict(model1, type="response", newdata = test)
summary(predictTest)
table(test$violator, predictTest > 0.5)

# Q5.2
# Sensitivity = TP / (TP + FN)
12 / (12 + 11)

# Specificity = TN / (TN + FP)
167 / (167 + 12)

# Accuracy 
(167 + 12) / (167 + 12 + 11 + 12)

# Q5.3 - Accuracy of baseline model
table(test$violator)
179 / (179 + 23)

# Q5.6
ROCRpred = prediction(predictTest, test$violator)
as.numeric(performance(ROCRpred, "auc")@y.values)

