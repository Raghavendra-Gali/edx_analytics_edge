##############################################################################
# WEEK 4 - Trees - D2Hawkeye
#


#caTools used to split dataframe into testing and training data
library(caTools)

# Need these libraries to make a CART model in Video 8
library(rpart)
library(rpart.plot)

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 6 : CLAIMS DATA IN R

# Claims data represents patients in Medicare (anonymized data)
#
# Random sample of 1% of patients still alive at the end of 2008
# Will be predicting cost in 2009
# Independent variables are the patient's age, and binary values to show
# if they were diagnosed with conditions (age to stroke)
# reimbursement2008/9 is the amount of reimbursements for the patient
# Bucket2008/9 is the cost bucket the patient fell into (from D2Hawkeye buckets)

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week4")
Claims = read.csv("ClaimsData.csv")
str(Claims)

# Check the cost buckets for 2009. 
# Gives the precentage of patients in each cost bucket
# Goal is to predict the bucket based on 2008 training data
table(Claims$bucket2009)/nrow(Claims)

# Divide data into training (60%) and test sets
set.seed(88)
spl = sample.split(Claims$bucket2009, SplitRatio = 0.6)
ClaimsTrain = subset(Claims, spl == TRUE)
ClaimsTest = subset(Claims, spl == FALSE)

# QUICK QUESTION
summary(ClaimsTrain)
table(ClaimsTrain$diabetes)

# VIDEO 7: BASELINE METHOD AND PENALTY MATRIX

# Check the baseline method. Predict cost bucket in 2009 would be same as 2008.
# Accuracy is the sum of the diagonal, divided by the number of examples
table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)

# Calculate baseline accuracy = 0.6838135
(110138 + 10721 + 2774 + 1539 + 104) / nrow(ClaimsTest)

# Need to calculate a penalty matrix, with actual outcomes on left, and 
# predicted outcomes on the top labels.
# Worst penalty is when we predict low cost bucket, actual is high cost bucket.
PenaltyMatrix = matrix(c(0,1,2,3,4, 2,0,1,2,3, 4,2,0,1,2, 6,4,2,0,1, 8,6,4,2,0 ),
                       byrow=TRUE,nrow=5)

# Can compute the penalty by multiplying previous table by penalty matrix
PenaltyBaseline = as.matrix(table(ClaimsTest$bucket2009, ClaimsTest$bucket2008)) * PenaltyMatrix

# Now to find the overall accuracy, sum the matrix and divide by # rows in ClaimsTest
# = 0.7386055 penalty error
sum(PenaltyBaseline) / nrow(ClaimsTest)

# QUICK QUESTION
nrow(ClaimsTest)
table(Claims$bucket2009)/nrow(Claims)

(0.190170413 * 2) + (0.089466272 * 4) + (0.043324855 * 6) + (0.005770679 * 8)

# VIDEO 8: PREDICTING HEALTHCARE COSTS IN R

# Build a CART model to predict the costs

ClaimsTree = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression 
                   + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke 
                   + bucket2008 + reimbursement2008, 
                   data = ClaimsTrain, method="class", cp = 0.00005)

# Not going to do Cross-Validation here to find the cp parameter, but can use the 
# Supreme Court code to decide what cp value to use.

# Plot the tree using the prp function
prp(ClaimsTree)

# Now use the CART tree to make predictions (which bucket)
PredictTest = predict(ClaimsTree, newdata = ClaimsTest, type="class")
table(ClaimsTest$bucket2009, PredictTest)

# Compute accuracy along diagonal = 0.71 compared to baseline 0.68
(114141 + 16102 + 118 + 201 + 0) / nrow(ClaimsTest)

# Compute penalty error = 0.76, baseline 0.74 (!?)
PenaltyBaselineCART = as.matrix(table(ClaimsTest$bucket2009, PredictTest)) * PenaltyMatrix
sum(PenaltyBaselineCART) / nrow(ClaimsTest)

# Rebuild the CART, using the penalty Matrix to guide model
ClaimsTreePenalty = rpart(bucket2009 ~ age + arthritis + alzheimers + cancer + copd + depression 
                   + diabetes + heart.failure + ihd + kidney + osteoporosis + stroke 
                   + bucket2008 + reimbursement2008, 
                   data = ClaimsTrain, method="class", cp = 0.00005,
                   parms=list(loss=PenaltyMatrix))

# Now re-check the accuracy and penalty values
PredictTestPenalty = predict(ClaimsTreePenalty, newdata = ClaimsTest, type="class")
table(ClaimsTest$bucket2009, PredictTestPenalty)

# Calculate accuracy = 0.647
(94310+18942+4692+636+2)/ nrow(ClaimsTest)

# Calculate penalty error = 0.642
PenaltyBaselineCART = as.matrix(table(ClaimsTest$bucket2009, PredictTestPenalty)) * PenaltyMatrix
sum(PenaltyBaselineCART) / nrow(ClaimsTest)
