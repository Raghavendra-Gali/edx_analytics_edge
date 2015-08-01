# KAGGLE COMPETITION - LOGISTIC REGRESSION BID VS NON-BID

# Split the dataset into biddable and non-biddable datasets, train separately

# libraries
library(caTools)
library(ROCR)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# As this is logistic regression-only, read in strings as factors. Not planning any text analysis (yet)
# So no stringsAsFactors=FALSE
# The eBayTest doesn't have the dependent variable in it, so we can't evaluate AUC on it :-(
ebay = read.csv("eBayiPadTrain.csv")
ebaySub = read.csv("eBayIpadTest.csv")
str(ebay)
summary(ebay)


# Pre-process storage : Change the storage factor into an integer.
# replace unknown values with the median (16)
summary(ebay$storage)
storageMedianIndex = median(as.numeric(ebay$storage))
storageMedian = ebay$storage[storageMedianIndex]
ebay$storage[ebay$storage == "Unknown"] = storageMedian
ebay$storageInteger = as.integer(as.character(ebay$storage))
summary(as.factor(ebay$storageInteger))

summary(ebaySub$storage)
storageMedianIndex = median(as.numeric(ebaySub$storage))
storageMedian = ebaySub$storage[storageMedianIndex]
ebaySub$storage[ebaySub$storage == "Unknown"] = storageMedian
ebaySub$storageInteger = as.integer(as.character(ebaySub$storage))
summary(as.factor(ebaySub$storageInteger))



# Pre-process price : 

# First, create a price dataframe
levels(ebay$productline)


levels(ebay$productline)

table(ebay$productline, ebay$storageInteger, ebay$cellular)

levels(ebay$storage)


# Pre-process cellular. If the network isn't None, it must be a cellular
# iPad !
table(ebay$carrier, ebay$cellular)

table(ebay$carrier == "None", ebay$cellular == "Unknown")

ebay$cellular[(ebay$carrier == "None") && (ebay$cellular == "Unknown")] = 1
table(ebay$carrier, ebay$cellular)

