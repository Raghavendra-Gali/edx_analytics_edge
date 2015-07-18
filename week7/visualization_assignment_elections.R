# VISUALIZATION - Assignment : Election Forecasting

# Need the ggplot2 library for fancy plots
library(ggplot2)

# Use the ggmap and maps packages 
library(ggmap)
library(maps)

# Change into the directory and load data
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

statesMap = map_data("state")

# 1.1 
str(statesMap)
table(statesMap$group)

# 1.2
ggplot(statesMap, aes(x = long, y = lat, group = group)) + geom_polygon(fill = "white", color = "black")

# 1.3 

# 2.1

# Read in the csv and call it 'polling'
polling = read.csv("PollingImputed.csv")
str(polling)

# Create Train with 2004 and 2008 data, and Test with 2012
Train = subset(polling, Year == 2008 | Year == 2004)
Test = subset(polling, Year == 2012)

# Create a logistic regression, and predict on the test set
mod2 = glm(Republican ~ SurveyUSA + DiffCount , data = Train, family="binomial")
TestPrediction = predict(mod2, type = "response", newdata = Test)
head(TestPrediction)
TestPredictionBinary = as.numeric(TestPrediction > 0.5)
predictionDataFrame = data.frame(TestPrediction, TestPredictionBinary, Test$State)
str(predictionDataFrame)
table(predictionDataFrame$Test.State, predictionDataFrame$TestPredictionBinary)

predictedRepublican = subset(predictionDataFrame, TestPredictionBinary == 1)
str(predictedRepublican)
summary(predictionDataFrame)

# 2.2

predictionDataFrame$region = tolower(predictionDataFrame$Test.State)
predictionMap = merge(statesMap, predictionDataFrame, by = "region")
predictionMap = predictionMap[order(predictionMap$order),]

str(predictionMap)
str(statesMap)

# 2.3 hmm.. why are there fewer predictMap observations than statesMap?
# The polling data only contains 45 states, not all 50 !
tail(predictionMap)

# 2.4
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + geom_polygon(color = "black")

# 2.5

# Plot the binary test prediction variable
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + 
    geom_polygon(color = "black") + 
    scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), 
                        labels = c("Democrat", "Republican"), name = "Prediction 2012")

# Now plot the continuous probability variable - it doesn't look any different !
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPrediction)) + 
  geom_polygon(color = "black") + 
  scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), 
                      labels = c("Democrat", "Republican"), name = "Prediction 2012")

# Quick check of the histogram to see what's going on ..
# .. most values are very close to 0 or 1 !
hist(predictionMap$TestPrediction)

# 3.1 
subset(predictionMap, region == "florida")

# 4.1 Reproduce the plots

# plot 1 (linetype)
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + 
  geom_polygon(color = "black", linetype=2) + 
  scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), 
                      labels = c("Democrat", "Republican"), name = "Prediction 2012")


# plot 2 (size)
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + 
  geom_polygon(color = "black", size=2) + 
  scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), 
                      labels = c("Democrat", "Republican"), name = "Prediction 2012")

# plot 3 (alpha)
ggplot(predictionMap, aes(x = long, y = lat, group = group, fill = TestPredictionBinary)) + 
  geom_polygon(color = "black", alpha=0.3) + 
  scale_fill_gradient(low = "blue", high = "red", guide = "legend", breaks= c(0,1), 
                      labels = c("Democrat", "Republican"), name = "Prediction 2012")

