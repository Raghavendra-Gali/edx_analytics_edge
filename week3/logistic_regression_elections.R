##############################################################################
# WEEK 3 - Logistic Regression - Recitation (Elections)
#

# Use the mice package for random imputation of missing survey results
library("mice")

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 2: DEALING WITH MISSING DATA

# Read in the dataset, check its structure
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
polling = read.csv("PollingData.csv")
str(polling)

# There are 50 states, and 3 years of elections, so should have 150 observations
# But in this dataset there are 145 !
# The pollers were so confident in the remaining 5 states in 2012 they didn't bother
# taking any polls (Alabama, Alaska, Delaware, Vermont, Wyoming)
table(polling$State, polling$Year)

# There are a lot of NA values (missing data) in the dataset. Check how many:
# Rasmusen and SurveyUSA both have missing data.
summary(polling)

# VIDEO 2: DEALING WITH MISSING DATA

# Use the mice package to do imputation. Limit the dataframe to just the 
# 4 polling data and put in 'simple' dataframe
simple = polling[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount")]
summary(simple)

# Set random seed to same value before imputation
set.seed(144)
imputed = complete(mice(simple))
summary(imputed)

# Err.. the imputed data looks nothing like the video data, despite the same seed
# Follow along with the re-merging and then overwrite with pre-imputed CSV.
polling$Rasmussen = imputed$Rasmussen
polling$SurveyUSA = imputed$SurveyUSA
summary(polling) # Notice no NA's now.

# Read in the imputed data, so the results match on the video
imputed = read.csv("PollingData_Imputed.csv")
summary(imputed)

# VIDEO 3: A SOPHISTICATED BASELINE METHOD

# Now we need to split the data into a training and test set as usual
# Train on data from 2004 and 2008 elections, and test on 2012

Train = subset(polling, polling$Year == 2004 | polling$Year == 2008)
Test = subset(polling, polling$Year == 2012)

# Now look at a baseline using the dependent variable in the training set
table(Train$Republican)

# Accuracy of baseline method is ~53%
53 / (53 + 47)

# This baseline is so basic that it predicts Republican for states that always
# vote Democratic (NY, CA, etc). Need a smarter baseline, so just predict based
# on one poll in isolation. 

# Sign() returns 1 for +ve, -1 for -ve, and 0 for 0. Rasmusen is +ve if the 
# Republican is polling ahead, -ve if Democrat is ahead. 0 means tie.
table(sign(Train$Rasmussen))

# Compare the training set prediction against the polling data
# In this table, rows are the true outcome (0=D, 1=R)
# Columns are predictions (-1=D, 0 = none, +1=R)
table(Train$Republican, sign(Train$Rasmussen))

# Accuracy of this baseline is ~94%
(42 + 52) / (42 + 2 + 3 + 1 + 52)

# VIDEO 4: LOGISTIC REGRESSION MODELS

# Good to check for co-linearity before making any models. The data set is likely
# to be strongly correlated as they will be predicting the same thing

# Can't take the cor() of the training set, because the states are a categorical value
str(polling)

# Just calculate the correlation between the numerical values and dependent variable
cor(Train[c("Rasmussen", "SurveyUSA", "PropR", "DiffCount", "Republican")])

# Strong correlations between SurveyUSA and Rasmussen (independent variables)
# If you had to make the model with only one independent variable, use the one
# that's most strongly correlated with the independent variable => PropR
mod1 = glm(Republican ~ PropR, family = "binomial", data=Train)
summary(mod1) # AIC = 19.8 (lower is better)

# Try predicting the outcomes, set threshold 0.5 and see how it does on training 
pred1 = predict(mod1, type="response")
table(Train$Republican, pred1 >= 0.5)  # 4 mistakes

# Try and find two variables which are highly correlated with the dependent 
# variable, but not correlated with each other.
mod2 = glm(Republican ~ SurveyUSA + DiffCount, family = "binomial", data=Train)
summary(mod2) # AIC = 18.439 (lower is better)

# Try predicting the outcomes (for model 2)
pred2 = predict(mod2, type="response")
table(Train$Republican, pred2 >= 0.5)  # 3 mistakes

# VIDEO 5: TEST SET PREDICTIONS

# First check the smart baseline model results on test set
table(Test$Republican, sign(Test$Rasmussen)) # 4 mistakes, 2 inconclusive 

# Now check the 2-variable model prediction
TestPrediction = predict(mod2, newdata = Test, type = "response")
table(Test$Republican, TestPrediction >= 0.5) # Only 1 mistake, predicted R, actual D

# Investigating testing set error
subset(Test, TestPrediction >= 0.5 & Republican == 0)
