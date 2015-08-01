# KAGGLE COMPETITION - DATA EXPLORATION

# Poke about in the data to look for clues, use visualization

#Use ggplot for heatmaps
library(ggplot2)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# We'll be doing NLP on the descriptions, so don't read strings as factors, and
# convert the actual factors back afterwards

ebay = read.csv("eBayiPadTrain.csv")
ebaySub = read.csv("eBayiPadTest.csv")

str(ebay)
str(ebaySub)

