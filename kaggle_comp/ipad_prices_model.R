# KAGGLE COMPETITION - LOGISTIC REGRESSION BID VS NON-BID

# Split the dataset into biddable and non-biddable datasets, train separately

# libraries
library(caTools)
library(ROCR)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# Load in the pricing csv
prices = read.csv("ipad_prices.csv")
summary(prices)
str(prices)

plot(prices$productline, prices$cellular)
prices



