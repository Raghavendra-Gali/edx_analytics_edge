##############################################################################
# WEEK 2 - Linear Regression - FLU
#

# Uncomment to clear workspace on every run
rm(list=ls())

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week2")
FluTrain = read.csv("FluTrain.csv")
str(FluTrain)
summary(FluTrain)



# 1.2
hist(FluTrain$ILI)

#1.3
plot(FluTrain$Queries, log(FluTrain$ILI))
     
# 2.2 Dependent var = log(ILI), independent var Queries. Queries coef should be +ve
FluTrend1 = lm(log(FluTrain$ILI) ~ FluTrain$Queries)
summary(FluTrend1)

correlation = cor(log(FluTrain$ILI) , FluTrain$Queries) # returns 0.8420333

# 2.3 What is the relationship between correlation and R2?
correlation^2
log(1/correlation)
exp(-0.5*correlation)

# 3.1 
FluTest = read.csv("FluTest.csv")
summary(FluTrain)
summary(FluTest)
PredTest1 = exp(predict(FluTrend1, newdata=FluTest))
which(FluTest$Week == "2012-03-11 - 2012-03-17")
PredTest1[11]

# 3.2
observed = 2.2934216
estimated = 2.187383

(observed - estimated) / observed

# 4.1
ILILag2 = lag(zoo(FluTrain$ILI), -2, na.pad=TRUE)
FluTrain$ILILag2 = coredata(ILILag2)

ILILag2[1:5]
FluTrain$ILI[1:5]

# 4.2
plot(log(ILILag2), log(FluTrain$ILI))

# 4.3
FluTrend2 = lm(log(FluTrain$ILI) ~ FluTrain$Queries + log(ILILag2))
summary(FluTrend1)
summary(FluTrend2)

# Comparing the two models : 
# R2 1 = 0.709, 2 = 0.9063
# Significance of coefficients : All are *** (Pr>|t| < 2e-16)


# 5.1
ILILag2 = lag(zoo(FluTest$ILI), -2, na.pad=TRUE)
FluTest$ILILag2 = coredata(ILILag2)

# 5.3 Need to copy last two training examples into first two test examples
# These are (from inspection) 1.5181061 1.6639544
fluTrainRows = nrow(FluTrain)
FluTest$ILILag2[1] = FluTrain$ILILag2[fluTrainRows-1]
FluTest$ILILag2[2] = FluTrain$ILILag2[fluTrainRows]

# 5.4
predictedData = exp(predict(FluTrend2, newdata=FluTest))

# Now predict the out-of-sample R-squared (how well does the model generalise?)
SSE = sum((predictedData - FluTest$ILI)^2)
SST = sum((mean(FluTest$ILI) - FluTest$ILI)^2)
R2 = 1 - (SSE/SST)
RMSE = sqrt(SSE/nrow(FluTest))


