##############################################################################
# WEEK 4 - Trees - Assignment : Why People Vote
#

#Libraries

# Calculate AUC with this library
library(ROCR)

# Use these libraries for the CART trees
library(rpart)
library(rpart.plot)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week4")
gerber = read.csv("gerber.csv")
str(gerber)
summary(gerber)

# 1.2
# Use a series of tables to check whichwas the largest group. Check the (1,1)
# corner of the table to see the corespondance
table(gerber$civicduty, gerber$voting)
table(gerber$hawthorne, gerber$voting)
table(gerber$self, gerber$voting)
table(gerber$neighbors, gerber$voting)

# 1.3
gerberLogReg = glm(voting ~ civicduty + hawthorne + self + neighbors, data=gerber)
summary(gerberLogReg)

# 1.4 - Convert linear regression into logistic regression with threshold of 0.3
gerberLogPredict = predict(gerberLogReg)
t = 0.3
table(gerberLogPredict > t, gerber$voting)
# Now get the accuracy (on diagonal) : 0.5419578
(134513+51966) / (134513+56730+100875+51966)

t = 0.5
table(gerberLogPredict > t, gerber$voting)

# Now get the accuracy (on diagonal) - # no true predictions : 0.684
(235388/(235388+108696))

# 1.6 - What is going on? 

# Work out the baseline accuracy = 0.684
table(gerber$voting)
(235388/(235388+108696))

# Check the AUC of the model

ROCRpred = prediction(gerberLogPredict, gerber$voting)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Bonus - plot the ROC curve too. Looks very flat to a straight line :-(
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

# 2.1 - Trees

# Create a CART regression tree using the same independent variables. There are 0 splits !
CARTmodel = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gerber)
prp(CARTmodel)

# 2.2 Re-try with a cp of 0 to examine splits. Now 4 splits are available
CARTmodel2 = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=gerber, cp = 0.0)
prp(CARTmodel2)

# 2.4 redo tree with'sex' included. 'sex' appears on all the leaf nodes 
CARTmodel3 = rpart(voting ~ civicduty + hawthorne + self + neighbors + sex, data=gerber, cp = 0.0)
prp(CARTmodel3)

# 2.4
# Calculate proportion who voted in control group
gerberControl = subset(gerber, control == 1)
table(gerberControl$sex)
table(gerberControl$sex, gerberControl$voting)
29015 / (29015 + 66809)
27715 / (27715 + 67704)

# Calculate proportion who voted in civid duty group
gerberCivicDuty = subset(gerber, civicduty == 1)
summary(gerberCivicDuty)
table(gerberCivicDuty$sex, gerberCivicDuty$voting)
(6165/(6165+12937))
(5856/(5856+13260))

# 3.1 Interaction Terms

# Create a regression tree using just 'control'
CARTmodelControl = rpart(voting ~ control, data=gerber, cp = 0.0)
prp(CARTmodelControl)
summary(CARTmodelControl)
0.3400004 - 0.2966383

# Create a regression tree with control and sex
CARTmodelControlSex = rpart(voting ~ control + sex, data=gerber, cp = 0.0)
prp(CARTmodelControlSex)
summary(CARTmodelControlSex)

# 3.3
gerberLogRegSexControl = glm(voting ~ sex + control, data=gerber, family="binomial")
summary(gerberLogRegSexControl)

# 3.4 - Creates a simple dataset of the 4 possibilities of (sex, control) 

Possibilities = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1))
predict(gerberLogRegSexControl, newdata=Possibilities, type="response")
# Prediction from LogReg for (woman, control) = 0.2906107
# Prediction from CARTmodelControlSex = 0.2904558
abs(0.2904558 - 0.2906107)

# 3.5
LogModel2 = glm(voting ~ sex + control + sex:control, data=gerber, family="binomial")
summary(LogModel2)

# 3.6 CART prediction is 0.2904558, this model gives 0.2904558
predict(LogModel2, newdata=Possibilities, type="response")
0.2904558 - 0.2904558

