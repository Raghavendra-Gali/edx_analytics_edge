##############################################################################
# WEEK 2 - Linear Regression - NBA
#

# VIDEO 1: THE DATA

# Uncomment to clear workspace on every run
# rm(list=ls())

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week2")
NBA = read.csv("nba_train.csv")
str(NBA) # 1232 observations of 15 variables

# The data contains the following variables
# Playoffs : binary value if the team made it to the playoffs
# W : How many wins
# PTS : Points scored by the team
# oppPTS : Points scored by the opponents
# FG : Field Goals (successful)
# FGA : Field Goal Attempts 
# X2P : 2 pointers (X added as prefix to numeric)
# X3P : 3 pointers (X added as prefix to numeric)
# ORB/DRB : Offensive ReBound, Defensive ReBound
# etc etc...

# VIDEO 2 : PLAYOFFS AND WINS

# Question : how many games does a team need to win to make it to the playoffs ?

# rows are number of games won, columns are whether they made it to playoffs
table(NBA$W, NBA$Playoffs) # After ~42 games won, very few teams don't make it to playoffs
plot(NBA$W, NBA$Playoffs)

# Can we use the difference between points scored and points allowed to predict
# whether a team makes it to the playoffs?
NBA$PTSdiff = NBA$PTS - NBA$oppPTS
plot(NBA$PTSdiff, NBA$W) # Very strong relationship here => use Linear Regression

# Create a linear model with PTSdiff as independent var, and W as dependent var
WinsReg = lm(W ~ PTSdiff, data=NBA)
summary(WinsReg) # R-squared is 0.94 (very strong)

# From the linear regression summary: W = 41 + 0.0326*PTSdiff
# Re-arranging above equation: (W - 41) / 0.0326 = PTSdiff
# You need W >= 42 to make it to the playoffs:
# (42-41) / 0.0326 = 30.67 points difference or more for 42 or more wins

# VIDEO 3 : POINTS SCORED

# Now want to build a model to predict points difference based on other variables

PointsReg = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + TOV + STL + BLK, data=NBA)
summary(PointsReg) # R-squared is 0.8992, pretty good

# Now compute SSE of residuals (sum of all squared residuals)
SSE = sum(PointsReg$residuals^2) # Hard to interpret this
RMSE = sqrt(SSE/nrow(NBA)) # Were making an error of 284 points
meanPoints = mean(NBA$PTS) # 8370 points scored on average, error of 284 not bad

# Now try dropping some variables to improve performance.
# Drop Turnovers (TOV) whose high P-value shows it's the least 
# statistically significant variable in the model
PointsReg2 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + DRB + STL + BLK, data=NBA)
summary(PointsReg2) # Adjusted R-squared 0.8982

# Now remove DRB (Defensive Rebounds) to see if it improves the model
PointsReg3 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL + BLK, data=NBA)
summary(PointsReg3) # No change in R-squared!

# Take off blocks (BLK)
PointsReg4 = lm(PTS ~ X2PA + X3PA + FTA + AST + ORB + STL, data=NBA)
summary(PointsReg4) # R-squared is 0.899

# Now check back with the SSE and RMSE (were 28,394,313 and 184.4 respectively)
SSE4 = sum(PointsReg4$residuals^2) # 28,421,465 (negligible change)
RMSE4 = sqrt(SSE/nrow(NBA)) # 184 (negligible change)

# VIDEO 4 : MAKING PREDICTIONS

# Training data included 1980 to 2011/2 seasons. Now load training set 2012/2013
NBATest = read.csv("NBA_test.csv")
PointsPredictions = predict(PointsReg4, newdata = NBATest)

# Now predict the out-of-sample R-squared (how well does the model generalise?)
SSE = sum((PointsPredictions - NBATest$PTS)^2)
SST = sum((mean(NBA$PTS) - NBATest$PTS)^2)
R2 = 1 - (SSE/SST)
RMSE = sqrt(SSE/nrow(NBATest)) # Average error of 196 points