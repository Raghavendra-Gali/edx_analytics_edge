# KAGGLE COMPETITION - HIERARCHICAL CLUSTERING

#Use ggplot for heatmaps
library(ggplot2)

library(caret)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

ebay = read.csv("eBayiPadTrain.csv")
ebaySub = read.csv("eBayiPadTest.csv")

# Combine the two ebay and ebaySub dataframes, remove unused cluster parameters
ebay$sold = NULL
ebay$UniqueID = NULL
ebaySub$UniqueID = NULL
ebayAll = rbind(ebay, ebaySub)
ebayAll$description = NULL

# Use the caret library to convert mean to 0, an standard deviation to 1
# summary(ebayAll)
# preproc = preProcess(as.matrix(ebayAll$startprice))
# ebayAll$startPrice = as.data.frame(predict(preproc, ebayAll$startprice))
# summary(ebayAll)

# Hierarchical clustering

# Compute pairwise distances between each of the observations
distances = dist(ebayAll, method="euclidean")

# Create clusters and plot them on a dendogram. 
clusters = hclust(distances, method = "ward.D")
plot(clusters)

# Based on the dendogram plot, choose a number of clusters and create them
clusterGroups = cutree(clusters, k = 4)
table(clusterGroups)

