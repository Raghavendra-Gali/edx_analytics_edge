##############################################################################
# WEEK 2 - Linear Regression
#

# VIDEO 4: LINEAR REGRESSION IN R

# Read in the wine dataset, and check its contents using str function
wine = read.csv("wine.csv")
str(wine) # 25 observations of 7 values

# Get the statistical summary for the variables
summary(wine)

# Create a model with 1 variable (AGST) with  lm function. 
# Syntax is lm( <dependent variable> ~ <independent variable>) 
model1 = lm(Price ~ AGST, data=wine)
summary(model1) # Adjusted R-squared is 0.4105

# Compute Sum of Squared Errors - SSE
SSE1 = sum(model1$residuals^2) # returns 5.73

# Now create a 2-variable model (AGST and harvest rain)
model2 = lm(Price ~ AGST + HarvestRain, data=wine)
summary(model2) # Adjusted R squared is now 0.6808 (from 0.4105)

# Compute Sum of Squared Errors - SSE
SSE2 = sum(model2$residuals^2) # returns 2.97

# Now create a 5-variable model:
# -AGST and harvest rain, winter rain, age, and France Population
model3 = lm(Price ~ AGST + HarvestRain + WinterRain + Age + FrancePop, data=wine)
summary(model3) # Adjusted R squared is now 0.7845

# Compute Sum of Squared Errors - SSE
SSE3 = sum(model3$residuals^2) # returns 1.732

# Quick Question (Model predicting Price using HarvestRain and WinterRain)

quickModel = lm(Price ~ HarvestRain + WinterRain, data=wine)
summary(quickModel)

# VIDEO 5: UNDERSTANDING THE MODEL
# The model for this section is 'model3' (using 5 variables)
summary(model3) # note Age and FrancePop aren't significant.

# Create a model4 with only the significant variables from model3.

model4 = lm(Price ~ AGST + HarvestRain + WinterRain + Age, data=wine)
summary(model4) # Adjusted R-squared is 0.7943 (higher than model3 with more variables!)

# VIDEO 6: CORRELATION AND MULTICOLLINEARITY

# Use the cor() function to compute the correlation between two variables
cor(wine$WinterRain, wine$Price)
cor(wine$Age, wine$FrancePop)

# To compute the correlation between all variables in the dataframe:
cor(wine)

# Now create a model using AGST, both Rains, but not Age or FrancePop 
# (which are highly correlated)
model5 = lm(Price ~ AGST + HarvestRain + WinterRain, data=wine)
summary(model5) # Adjusted R-squared is 0.7185

# VIDEO 7: MAKING PREDICTIONS

# Some samples were held back from the training set, now use these
# to test the model. This csv contains 2 samples.
wineTest = read.csv("wine_test.csv")
str(wineTest)

# model4 had AGST, HarvestRain, WinterRain, and Age. 
# Predict the price using wineTest as a test set
predictTest = predict(model4, newdata=wineTest)

# Looks like predictions are good, let's compute R-squared for this test set

SSETest = sum((wineTest$Price - predictTest)^2)
SSTTest = sum((wineTest$Price - mean(wine$Price))^2)
RSquaredTest = 1 - (SSETest/SSTTest) # 0.7944, not bad !
