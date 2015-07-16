##############################################################################
# WEEK 6 - Clustering - Assignment:  Airlines clustering
#

# caret library is used to normalise the variables
library(caret)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# Read in the healthy MRI dataset, convert to matrix, and check size
airlines = read.csv("AirlinesCluster.csv", stringsAsFactors = FALSE)
str(airlines)
summary(airlines)
# Dataset contents
# Balance = number of miles eligible for award travel
# QualMiles = number of miles qualifying for TopFlight status
# BonusMiles = number of miles earned from non-flight bonus transactions in the past 12 months
# BonusTrans = number of non-flight bonus transactions in the past 12 months
# FlightMiles = number of flight miles in the past 12 months
# FlightTrans = number of flight transactions in the past 12 months
# DaysSinceEnroll = number of days since enrolled in the frequent flyer program

# 1.3 - Normalise the data
preproc = preProcess(airlines)
airlinesNorm = predict(preproc, airlines)

# Now the data has 0 mean, and s.d. of 1
summary(airlinesNorm)
sd(airlinesNorm$Balance)
sd(airlinesNorm$BonusTrans)

# 2.1 Do hierarchical clustering, and plot dendogram
distances = dist(airlinesNorm, method="euclidean")

# cluster the articles using the previous distances and ward.D algorithm
clusters = hclust(distances, method = "ward.D")
plot(clusters)

# 2.2 - Divide the data into 5 clusters
clusterGroups = cutree(clusters, k = 5)
table(clusterGroups)

# 2.3 Compute average values for 5 clusters
tapply(airlines$Balance, clusterGroups, mean)
tapply(airlines$QualMiles, clusterGroups, mean)
tapply(airlines$BonusMiles, clusterGroups, mean)
tapply(airlines$BonusTrans, clusterGroups, mean)
tapply(airlines$FlightMiles, clusterGroups, mean)
tapply(airlines$FlightTrans, clusterGroups, mean)
tapply(airlines$DaysSinceEnroll, clusterGroups, mean)

# 3.1 K Means clustering with k = 5
set.seed(88)
k = 5
KMC = kmeans(airlinesNorm, centers=k, iter.max = 1000)
str(KMC)
table(KMC$cluster)






