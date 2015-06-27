##############################################################################
# WEEK 3 - Logistic Regression - Assignment - Loans
#

# Use caTools in problem 3.1 to split data into training and test data
library(caTools)

# ROCR is used to plot ROC curves
library("ROCR")

# Uncomment to clear workspace on every run
rm(list=ls())

# Dataframe columns
# 
# credit.policy: 1 if the customer meets the credit underwriting criteria of LendingClub.com, and 0 otherwise.
# purpose: The purpose of the loan (takes values "credit_card", "debt_consolidation", "educational", "major_purchase", "small_business", and "all_other").
# int.rate: The interest rate of the loan, as a proportion (a rate of 11% would be stored as 0.11). Borrowers judged by LendingClub.com to be more risky are assigned higher interest rates.
# installment: The monthly installments ($) owed by the borrower if the loan is funded.
# log.annual.inc: The natural log of the self-reported annual income of the borrower.
# dti: The debt-to-income ratio of the borrower (amount of debt divided by annual income).
# fico: The FICO credit score of the borrower.
# days.with.cr.line: The number of days the borrower has had a credit line.
# revol.bal: The borrower's revolving balance (amount unpaid at the end of the credit card billing cycle).
# revol.util: The borrower's revolving line utilization rate (the amount of the credit line used relative to total credit available).
# inq.last.6mths: The borrower's number of inquiries by creditors in the last 6 months.
# delinq.2yrs: The number of times the borrower had been 30+ days past due on a payment in the past 2 years.
# pub.rec: The borrower's number of derogatory public records (bankruptcy filings, tax liens, or judgments).

setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
loans = read.csv("loans.csv")
summary(loans)
str(loans)

table(loans$not.fully.paid)
1533 / (1533 + 8045)

# Q1.3

# Quick check to see how is.na() works:
table(is.na(loans$days.with.cr.line))

# Q1.4 - The imputed values didn't match in the elections recitation, load
#        the supplied cvs in instead
loans = read.csv("loans_imputed.csv")

# Q2.1

# Split the data into training and test data using sample.split 
# and 70% training data
set.seed(144)
split = sample.split(loans$not.fully.paid, SplitRatio = 0.7)
train = subset(loans, split == TRUE)
test = subset(loans, split == FALSE)

# Build a model using the training data
predictTrain = glm(not.fully.paid ~ ., family = "binomial", data = train)
summary(predictTrain)

# Q2.2
logitDiff = -9.317e-03 * -10
odds = exp(logitDiff)

# Q2.3
test$predicted.risk = predict(predictTrain, type = "response", newdata = test)
table(test$not.fully.paid, test$predicted.risk > 0.5)

# Accuracy
(2400 + 3) / (2400 + 13 + 457 + 3)

# Baseline accuracy
table(test$not.fully.paid)
(2413 / (2413+460))

# Q2.4 AUC
ROCRpred = prediction(test$predicted.risk, test$not.fully.paid)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Q3.1
biVariateTrain = glm(not.fully.paid ~ int.rate, family = "binomial", data = train)
biVariatePredTest = predict(biVariateTrain, type = "response", newdata = test)
max(biVariatePredTest)
table(test$not.fully.paid, biVariatePredTest > 0.5)

# Q3.3 AUC
ROCRpred = prediction(biVariatePredTest, test$not.fully.paid)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Q4.1 
10 * exp(0.06 * 3)

# Q5.1 - Profit calculations
# If loan paid in full, profit is c * exp(rt) - c
test$profit = exp(test$int.rate*3) - 1
test$profit[test$not.fully.paid == 1] = -1
table(test$profit)

# Q6.1
highInterest = subset(test, int.rate > 0.15)
summary(highInterest)

# Q6.2
cutoff = sort(highInterest$predicted.risk, decreasing=FALSE)[100]
selectedLoans = subset(highInterest, predicted.risk <= cutoff)
summary(selectedLoans)


