##############################################################################
# WEEK 4 - Trees - Boston house prices
#

#caTools used to split dataframe into testing and training data
library(caTools)

# Need these libraries to make a CART model in Video 8
library(rpart)
library(rpart.plot)

# These libraries are used for cross-validation
library(caret)
library(e1071)

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 2 : THE DATA

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week4")
boston = read.csv("boston.csv")
str(boston)

# Want to build a model of how house prices vary across the region
plot(boston$LON, boston$LAT)

# plot just the points where the 'Charles River' variable is 1
# and highlight in blue
points(boston$LON[boston$CHAS==1],boston$LAT[boston$CHAS == 1], col="blue", pch=19)

# MIT is in tract 3531, add this to the plot too
points(boston$LON[boston$TRACT==3531], boston$LAT[boston$TRACT==3531], col="red", pch=19)

# Data set was originally checking on how air pollution affects house prices
# NOX is an air pollutant. Mean is ~0.55
summary(boston$NOX)

points(boston$LON[boston$NOX >= 0.55], boston$LAT[boston$NOX>=0.55], col="green", pch = 19)

# Let's makea new plot, to check house prices. Start
# with a new graph. Min price ~ 5k, max 50k
plot(boston$LON, boston$LAT)
summary(boston$MEDV)

# Plot houses over median price as red blobs. There is some structure, but it's 
# not obvious. There's no linear relationship to the data
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)

# VIDEO 3: GEOGRAPHICAL PREDICTIONS

# Check how the latitude and longitude relate to prices
plot(boston$LAT, boston$MEDV) # Not linear !
plot(boston$LON, boston$MEDV) # Not linear !

# Try fitting a linear regression to start with. Plot all the houses predicted
# >= median price and compare to prvious plot
latlonlm = lm(MEDV ~ LAT + LON, data=boston)
summary(latlonlm)
plot(boston$LON, boston$LAT)

# Overlay actual above-median prices as red dots
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV>=21.2], col="red", pch=19)

# Overlay what the model predicts as above-median prices
# Using a blue dollar-sign, so you can see correspondance with actual values
# Big gap on the east of the plot, and a lot of values are missing.
points(boston$LON[latlonlm$fitted.values>=21.2], boston$LAT[latlonlm$fitted.values>= 21.2], col="blue", pch="$")

# VIDEO 4: REGRESSION TREES

# Plot the tree formed by the regression
# The number predicted is the median housing value
LatLonTree = rpart(MEDV ~ LAT + LON, data=boston)
prp(LatLonTree)

# Now visualise the regression tree on the lat/lon plot
plot(boston$LON, boston$LAT)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV >= 21.2], col="red", pch=19)
fittedValues = predict(LatLonTree)
points(boston$LON[fittedValues>=21.2], boston$LAT[fittedValues >= 21.2], col="blue", pch="$")

# Suspect the tree may be overfitting (based on what ?!)
# Try re-running with a cp command to control it
LatLonTreeCP = rpart(MEDV ~ LAT + LON, data=boston, minbucket=50)

# This is another way of representing a tree, similar to hierarchical clustering
plot(LatLonTreeCP)
text(LatLonTreeCP)

# now plot these splits on the LAT/LON plot
plot(boston$LON, boston$LAT)
abline(v=-71.07)
abline(h=42.21)
abline(h=42.17)
points(boston$LON[boston$MEDV>=21.2], boston$LAT[boston$MEDV >= 21.2], col="red", pch=19)

# notice the regression tree has carved out a low-price rectangle on teh map

# VIDEO 5: PUTTING IT ALL TOGETHER

# Let's predict house prices using all the variables
set.seed(123)
split = sample.split(boston$MEDV, SplitRatio = 0.7)
train = subset(boston, split==TRUE)
test = subset(boston, split==FALSE)
linreg = lm(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train)
summary(linreg)

# Evaluating linear reg model:
# LAT and LON don't matter much as linear regression can't separate them
# Main significant factors are: CRIM, NOX, RM, DIS, PTRATIO
# May be correlated, haven't checked yet.

# Need to think how to evaluate model. Can't use accuracy, specificity or
# sensitivity as it'sn not a classification mode. Use SSE instead
# SSE for linear regression is 3037
linreg.pred = predict(linreg, newdata=test)
linreg.sse = sum((linreg.pred - test$MEDV)^2)

# Can we beat this SSE using a regression tree ?
# LAT and LON aren't important for regression tree either.
# Main variables are RM (3 splits), NOX, CRIM and AGE
tree = rpart(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO, data = train)
prp(tree)

# Now predict based on the tree, calculate SSE
# SSE for regression tree is 4329 (worse than linear regression)
tree.pred = predict(tree, newdata=test)
tree.sse = sum((tree.pred - test$MEDV)^2)
tree.sse
                    
# This shows LAT and LON really aren't useful compared to other variables

# VIDEO 7 : CROSS_VALIDATION

set.seed(123)

# Set it to do cross-validation, across 10 folds
tr.control = trainControl(method="cv", number=10)

# Now tell it which range of parameters to try out
# cp varies between 0 and 1, but we probably don't need to check
# this whole range. Make a grid as follows:
# 0:10 generates integers 0 to 10 (inclusive), these are then multiplied by 0.001
cp.grid = expand.grid(.cp = (0:10)*0.001)

tr = train(MEDV ~ LAT + LON + CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO,
           data=train, method="rpart", trControl = tr.control, tuneGrid = cp.grid)

# Print out the results of cross-validation, check RMSE
tr

# This shows a value of cp = - should be used, with smallest RMSE of 4.939
# This means a very detailed tree is needed.

best.tree = tr$finalModel
prp(best.tree)


# Is the best tree going to beat the linear regression model?
# This tree's SSE is 3675. Better than previous tree, but still not as good as linear regression
best.tree.pred = predict(best.tree, newdata=test)
best.tree.sse = sum((best.tree.pred - test$MEDV)^2)
best.tree.sse




