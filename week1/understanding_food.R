##############################################################################
# Week 1 : An introduction to analytics
##############################################################################

##############################################################################
# RECITATION : Understanding Food: Nutritional Educatin with Data
#

# - More than 35% of US adults are bese
# - 65% of world's population lives in countries where obesity kills more people
#   than malnourishment
# - 15% of adults have food-related apps on their phones.
# - US Department of Agriculture (USDA) maintains a database of nutritional
#   info for over 7000 food items. This is used in the analysis below.
#

##############################################################################
# VIDEO 2: WORKING WITH DATA IN R

# First load in the dataset by changing into the directory
setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")
USDA = read.csv("USDA.csv")

# Now learn about the data in the USDA CSV file
# ID = unique ID for each foodstuff
str(USDA)

# Report high-level statistics about the dataset. 
# WTF IS GOING ON WITH SODIUM ?! MAX is 38758.0 !!
summary(USDA)

##############################################################################
# VIDEO 3: DATA ANALYSIS

# To find out which of the foods has the maximum sodium value, use which.max:
which.max(USDA$Sodium) # returns 265

# Now to remind myself of the labels of each of the variables, use names():
names(USDA)

# now get the 265th description
USDA$Description[265]

# Or you can roll it all into a one-liner if you're being fancy :-)
USDA$Description[which.max(USDA$Sodium)]

# Now how about a subset of foods which have a sodium of > 10000 ? Use subset()
HighSodium = subset(USDA, Sodium>10000)

# To find out how many foods there are in the HighSodium group, use nrow()
nrow(HighSodium)

# Now list the high sodium foods
HighSodium$Description

# Now investigate why Caviar hasn't appeared in the high sodium dateframe. 
# Search the dataframe as below:
match("CAVIAR", USDA$Description) # returns 4154

# How much sodium does caviar have?
USDA$Sodium[4154] # returns 1500

# Do the above two commands in a one-liner
USDA$Sodium[match("CAVIAR", USDA$Description)]

# now go into more detail on sodium (this doesn't include standard deviation)
summary(USDA$Sodium)

# So calculate standard deviation of sodium
sd(USDA$Sodium) # returns NA !

# Repeat above step but remove NA's
sd(USDA$Sodium, na.rm = TRUE)

##############################################################################
# VIDEO 4: CREATING PLOTS IN R

# More visualization info in week 8 of the course

## Scatter plots ##

# Scatter-plot protein on x axis, and fat on y axis. 
# Looks like a triangular shape
plot(USDA$Protein, USDA$TotalFat)

# Add some more labels to the plot, and change colour to red
plot(USDA$Protein, USDA$TotalFat, xlab="Protein", ylab="Fat", main="Protein vs Fat", col="red")

## Histograms ##

# Now try a histogram of Vitamin C in the foods
hist(USDA$VitaminC, xlab = "Vitamin C (mg)", main = "Histogram of Vitamin C") # Very bunched up below 250mg

# Redo the histogram, zooming in on 100mg or less
hist(USDA$VitaminC, xlab = "Vitamin C (mg)", main = "Histogram of Vitamin C", xlim = c(0, 100)) # One flat value !

# Redo the histogram, specifying we want 100 bins in the histogram -> Only produces 5 bins because max is 2000mg
# and we asked for 100 cells which are spaced by 2000mg/100 = 20mg.
hist(USDA$VitaminC, xlab = "Vitamin C (mg)", main = "Histogram of Vitamin C", xlim = c(0, 100), breaks = 100)

# To get 100 bins need to specify 2000 breaks (across all 2000mg)
hist(USDA$VitaminC, xlab = "Vitamin C (mg)", main = "Histogram of Vitamin C", xlim = c(0, 100), breaks = 2000)

## Boxplots ##

# now try a a boxplot of sugar levels. There are hundreds of outliers
boxplot(USDA$Sugar, main = "Boxplot of sugar levels", ylab = "Sugar (g)")

##############################################################################
# VIDEO 5: ADDING VARIABLES

# Want to add a value to the dataframe to indicate high sodium.

USDA$Sodium[1] > mean(USDA$Sodium, na.rm=TRUE) # returns TRUE 
USDA$Sodium[50] > mean(USDA$Sodium, na.rm=TRUE) # returns FALSE 

# Create a vector across the dataset to indicate high sodium.
# This returns "logicals" (booleans)
HighSodium = USDA$Sodium > mean(USDA$Sodium, na.rm=TRUE)
str(HighSodium)

# To convert FALSE to 0, and TRUE to 1:
HighSodium = as.numeric(USDA$Sodium > mean(USDA$Sodium, na.rm=TRUE))

# Now to add the high sodium vector to the dataframe:
USDA$HighSodium = as.numeric(USDA$Sodium > mean(USDA$Sodium, na.rm=TRUE))
str(USDA) # Shows a new 17th variable (HighSodium) which we created

# Do the same for protein ..
USDA$HighProtein = as.numeric(USDA$Protein > mean(USDA$Protein, na.rm=TRUE))
# .. and also fat ..
USDA$HighFat = as.numeric(USDA$TotalFat > mean(USDA$TotalFat, na.rm=TRUE))
# .. and also carbs.
USDA$HighCarbs = as.numeric(USDA$Carbohydrate > mean(USDA$Carbohydrate, na.rm=TRUE))

##############################################################################
# VIDEO 6: SUMMARY TABLES

# Now use the HighSodium, HighProtein, HighFat, and HighCarbs to filter a table
# using tapply

# Count how many high sodium foods there are
table(USDA$HighSodium) # 4884 lower sodium than average, 2090 higher than avg

# Compare high sodium and high fat foods. Rows = high sodium, cols = high fat
table(USDA$HighSodium, USDA$HighFat)

# now use tapply(arg1, arg2, arg3) to drill down into the data.
# => "Group arg1 by arg2, and apply arg3"

# Want to compute the average amount of iron, sorted by high and low protein
tapply(USDA$Iron, USDA$HighProtein, mean, na.rm=TRUE)

# now analyse the max vitamin C content, sorted by high and low carbs
tapply(USDA$VitaminC, USDA$HighCarbs, max, na.rm=TRUE)

# Interesting .. does this mean food high in vitamin c is also high in carbs?
# use the summary function for more info:
tapply(USDA$VitaminC, USDA$HighCarbs, summary, na.rm=TRUE) #`0` is low carb, `1` is high carb

boxplot(USDA$HighCarbs, USDA$VitaminC)
