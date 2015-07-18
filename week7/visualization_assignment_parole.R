# VISUALIZATION - Assignment : Tweets

# plotting library ggplot
library(ggplot2)

# Change into the directory and load data
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

parole = read.csv("parole.csv")
str(parole)

# 1.1 Convert the sex, state, and crime to categorical variables
parole$male = as.factor(parole$male)
parole$state = as.factor(parole$state)
parole$crime = as.factor(parole$crime)

summary(subset(parole, violator == TRUE))
14/(14+64)

# 1.2 Most common Kentucky crime (state number 2)
summary(subset(parole, state == 2))

# 2.1 Creating a histogram
ggplot(data = parole, aes(x = age)) + geom_histogram(binwidth = 5, color="blue")

# 3.1 Adding sex information as well as age. Top histogram is female, bottom is male
ggplot(data = parole, aes(x = age)) + geom_histogram(binwidth = 5) + facet_grid(male ~ .)

# 3.2 Adding another dimension
ggplot(data = parole, aes(x = age)) + geom_histogram(binwidth = 5) + facet_grid(. ~ male)

# 3.3 Adding another dimension
# This is a color blind friendly palette
colorPalette = c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
ggplot(data = parole, aes(x = age, fill = male)) + 
  geom_histogram(binwidth = 5) + 
  scale_fill_manual(values = colorPalette)

# 3.4 
ggplot(data = parole, aes(x = age, fill = male)) + 
  geom_histogram(binwidth = 5, position="identity", alpha=0.5) + 
  scale_fill_manual(values = colorPalette)

# 4.1
ggplot(data = parole, aes(x = time.served, fill = male)) + 
  geom_histogram(binwidth = 1, position="identity", alpha=0.5) + 
  scale_fill_manual(values = colorPalette)

# 4.2
ggplot(data = parole, aes(x = time.served, fill = male)) + 
  geom_histogram(binwidth = 0.1, position="identity", alpha=0.5) + 
  scale_fill_manual(values = colorPalette)

# 4.3
ggplot(data = parole, aes(x = time.served)) + 
  geom_histogram(binwidth = 1) + 
  facet_grid(crime ~ time.served)

# 4.4 
ggplot(data=parole, aes(x=time.served, fill=crime)) + 
  geom_histogram(binwidth=1, position="identity", alpha=0.5)



