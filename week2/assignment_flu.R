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

table(FluTrain)