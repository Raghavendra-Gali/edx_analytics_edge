##############################################################################
# WEEK 2 - Linear Regression - Moneyball
#

# VIDEO 2: MAKING IT TO THE PLAYOFFS

# Based on inspection of the games won vs made-it-to-the-playoffs plot, you
# need to win 95 games to make it to the playoffs.
# todo ! Should be a simple logistic regression to calculate this ...

# Uncomment to clear workspace on every run
# rm(list=ls())

# Q: How many more runs do you need to score than your opponents to win 95 games?

# First load in the dataset
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week2")
baseball = read.csv("baseball.csv")
str(baseball) # 1232 observations of 15 variables

# Subset the data so it only includes years up to 2002 (to match the A's data)
moneyball = subset(baseball, Year < 2002)
str(moneyball)

# Need to create a new variable to show the Run Difference (RD) in each of the games
moneyball$RD = moneyball$RS - moneyball$RA
str(moneyball)

# Quick sanity check - is there a relationship between runs scored and wins?
plot(moneyball$RD, moneyball$W) # Definitely !

# Now create a linear regression model to find the relationship
WinsReg = lm(W ~ RD, data=moneyball)
summary(WinsReg) # R-squared 0.88, looks good.

# VIDEO 3: PREDICTING RUNS

# The dataset includes OBP, SLG, and BA. 
# Which are the best predictors for runs scored?

str(moneyball)
RunsReg = lm(RS ~ OBP + SLG + BA, data=moneyball)
summary(RunsReg) # R-squared = 0.93, Coefficient for BA is negative !

# Try another model without BA
RunsReg = lm(RS ~ OBP + SLG, data=moneyball)
summary(RunsReg) # 

# The dataset also has Pitching statistics
# These can be used to predict Runs Allowed based on OOBP and OSLG
RunsAllowedReg = lm(RA ~ OOBP + OSLG, data=moneyball)
summary(RunsAllowedReg) # Adjusted R-squared of 0.91 => good predictor


# VIDEO 4: USING THE MODELS TO MAKE PREDICTIONS

# Can we predict how many games the A's will win in 2002?
# Team statistics change every year, but we can estimate based on previous year


# Quick Question - Best players on a 1.5 million dollar budget
players = read.csv("quick_q_players.csv")
players

# Now calculate their Runs Scored prediction
players$RS = predict(RunsReg, newdata=players)
players$Value = players$RS / players$Salary


# Quick Question : Rankings and playoffs
teamRank = c( 1, 2, 3, 3, 4, 4, 4, 4, 5, 5)
wins2012 = c(94,88,95,88,93,94,98,97,93,94)
wins2013 = c(97,97,92,93,92,96,94,96,92,90)

cor(teamRank, wins2012)
cor(teamRank, wins2013)


