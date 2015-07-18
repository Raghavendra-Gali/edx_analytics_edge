# KAGGLE COMPETITION - GETTING STARTED

# Need the ggplot2 library for fancy plots
library(ggplot2)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

# Read in the dataset
WHO = read.csv("WHO.csv")
str(WHO)

# Scatterplot of GNI vs fertility rate
plot(WHO$GNI, WHO$FertilityRate)

# Now redo the same plot, using ggplot to make it look fancy !
# Need to define data, aesthetic mapping, and geometric object for ggplot

# Start by setting the dataframe source, and x and y axes
scatterplot = ggplot(WHO, aes(x = GNI, y = FertilityRate))
scatterplot + geom_point()

# The plot has updated with nice gridlines, solid points, and no $s 
# in the axis labels

# Now specify blue triangles of size 3 for the points
scatterplot + geom_point(color="blue", size=3, shape=17)

# Now change blue to dark red, and use stars
scatterplot + geom_point(color="darkred", size=3, shape=8)

# Add a title onto the plot as well using ggtitle()
scatterplot + geom_point(color="darkred", size=3, shape=8) + ggtitle("Fertility Rate vs Gross National Income")

# Now save the plot to a file. First, assign the scatterplot to a variable
fertilityGNIplot = scatterplot + geom_point(color="darkred", size=3, shape=8) + ggtitle("Fertility Rate vs Gross National Income")

# Now create a file to save the plot to. This creates a PDF called Myplot.pdf
# and saves the plot in there.
pdf("Myplot.pdf")
print(fertilityGNIplot)
dev.off()

# QUICK QUESTION
scatterplot + geom_point(color="darkred", size=3, shape=15) + ggtitle("Fertility Rate vs Gross National Income")

# VIDEO 5: ADVANCED SCATTERPLOTS USING GGPLOT

# Use existing plot, but add a color option for the region too
ggplot(WHO, aes(x = GNI, y = FertilityRate, color=Region)) + geom_point()

# Quick test to see if the blobs can be made larger
ggplot(WHO, aes(x = GNI, y = FertilityRate, color=Region)) + geom_point(size=4)

# Now colour the points according to the life expectancy 
# The continuous variable gives a gradient instead of different colours
ggplot(WHO, aes(x = GNI, y = FertilityRate, color=LifeExpectancy)) + geom_point(size=4)

# Check if the fertility rate was a good predictor of the population < 15
# Need geom_point for a scatter plot.
ggplot(WHO, aes(x = FertilityRate, y = Under15)) + geom_point()

# Doesn't look like a linear relationship, might be log though ..
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point()

# This looks much better. Now try fitting a linear regression to this
model = lm(Under15 ~ log(FertilityRate), data = WHO)

# R2 is 0.9391 for log model, very nice
summary(model)

# now re-plot the scatter points with the regression line (blue line)
# The shaded line is the confidence interval (95% by default)
# Change this to 99%
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm", level=0.99)

# Can also remove the confidence interval using se = false
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm", se = FALSE)

# Specify an orange line, with no confidence interval 
ggplot(WHO, aes(x = log(FertilityRate), y = Under15)) + geom_point() + stat_smooth(method="lm", se = FALSE, color = "orange")

# QUICK QUESTION

# Can add the 'scale_color_brewer' to make the colours more colourblind-friendly
ggplot(WHO, aes(x = FertilityRate, y = Under15, color = Region)) + geom_point(size=5) + scale_color_brewer(palette="Dark2") 


