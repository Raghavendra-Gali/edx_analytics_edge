##############################################################################
# WEEK 2 - Linear Regression - Climate Change Assignment
#

# VIDEO 1: THE DATA

# Uncomment to clear workspace on every run
rm(list=ls())

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week2")
climate = read.csv("climate_change.csv")
str(climate) # 1232 observations of 15 variables
summary(climate) # 308 obs. of  11 variables

# Split using year into:
# - Training (up to and including 2006) 
# - Test set (remaining years)
climateTrain = subset(climate, Year <= 2006)
climateTest = subset(climate, Year > 2006)
str(climateTrain) # 284 observations
str(climateTest) # 24 observations

# Build a linear regression model as in question
climateModel = lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data=climateTrain)
summary(climateModel)

# Which gases is N2O highly correlated with (0.7 or greater)?
cor(climateTrain) > 0.7

# PROBLEM 3 : Simplifying the Model
simpleModel = lm(Temp ~ MEI + TSI + Aerosols + N2O, data=climateTrain)
summary(simpleModel)

# PROBLEM 4 : Automatically building model
autoModel = step(climateModel)
summary(autoModel)

# PROBLEM 5 : Predict model
predictedData = predict(autoModel, newdata = climateTest)

# Now predict the out-of-sample R-squared (how well does the model generalise?)
SSE = sum((predictedData - climateTest$Temp)^2)
SST = sum((mean(climateTest$Temp) - climateTest$Temp)^2)
R2 = 1 - (SSE/SST)
RMSE = sqrt(SSE/nrow(climateTest))


