##############################################################################
# Week 1 : An introduction to analytics
##############################################################################

##############################################################################
# VIDEO 3: Vectors and data frames
#

# Create a vector of strings, and one of 
Country = c("Brazil", "China", "India", "Switzerland", "USA")
LifeExpectancy = c(74, 76, 65, 83, 79)

# Generate an arbitrary sequence of numbers
sequence = seq(0,100,2)

# Create a dataframe combining multiple vectors
CountryData = data.frame(Country, LifeExpectancy)

# Link a new variable into an existing dataframe (population of the countries)
CountryData$Population = c(199000, 1390000, 1240000, 7997, 318000)


# Now we want to add in some new countries to the existing vector in the dataframe
Country = c("Australia", "Greece")
LifeExpectancy = c(82, 81)
Population = c(23050, 11125)
# Create a new dataframe with these two vectors
NewCountryData = data.frame(Country, LifeExpectancy, Population)
# Now combine the previous countries and the new ones in one dataframe
AllCountryData = rbind(CountryData, NewCountryData)


##############################################################################
# VIDEO 4: Loading Data Files
#

# Change directory into the CSV location, and read it in

setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")
WHO = read.csv("WHO.csv")
  
# This command prints a summary of the data contained in the CSV.
# Factor variables are category values (e.g. Region has 6 different categories)
# int means an integer variable
# num is a non-integer variable
str(WHO)

# Summary prints out a list of statistics for each of the values in the CSV
# This includes quartiles, mean, median for numerical values
# It also reports when values are missing in the data, under NA's.
summary(WHO)

# To get a subset of the data frame, use the subset function. 
# The syntax is: Variable = subset(<source variable>, rule to get subset)
WHO_Europe = subset(WHO, Region == "Europe")
str(WHO_Europe)

# To write out a dataframe to a CSV file, use the function below:
write.csv(WHO_Europe, "WHO_Europe.csv")

# Check which variables we currenty have stored
ls()
#Remove WHO_Europe to save space
rm(WHO_Europe)
ls()


##############################################################################
# VIDEO 5 : Data Analysis - Summary statistics and scatterplots
#

# To access the 'Under15' vector inside the WHO dataframe, use the dollar notation:
WHO$Under15

# To compute the mean of Under15:
mean(WHO$Under15)

# To compute standard deviation of Under15
sd(WHO$Under15)

# To generate summary of just the Under15 vector:
# First quartile is the value for which 25% of the data is less than that value
# Third quartile is the value for which 75% of the data is less than that value
summary(WHO$Under15)

# The which.min function returns the row number for the minimum column given in dollar notation
which.min(WHO$Under15) # returns 86

# To find out which country is in row 86, use the square brackets
WHO$Country[86]

# Similarly, use the which.max() to find out which country has the maximum amount of 
# people under 15

which.max(WHO$Under15) # returns row 124
WHO$Country[124]

# Create a scatter plot using plot(x-axis vector, y axis vector)
plot(WHO$GNI, WHO$FertilityRate)

# Looks like by and large, Fertility rate is inversely proportional to the GNI of the country 
# BUT ! There are some outliers. Let's investigate ! Create a subset with the conditions 
# we're interested in (GNI and FertilityRate)
Outliers = subset(WHO, GNI > 10000 & FertilityRate > 2.5)

# This should return only GNI's over 10000 (as the filter above says)
summary(Outliers$GNI)

# This will give a count of how many rows in the Outliers data frame
nrow(Outliers)

# Now we want to extract a few key fields for the countries in the Outliers only.
# There are a total of 13 variables, narrow down to just the three shown below.
Outliers[c("Country", "GNI", "FertilityRate")]

# Useful patterns "which country has the maximum Fertility Rate"
# => WHO$Country[which.max(WHO_$FertilityRate)]


##############################################################################
# VIDEO 6: DATA ANALYSIS - PLOTS AND SUMMARY TABLES
#

# There are other plots in R as well as scatter plots, e.g. histograms and box plots

# Histrogram of cellular subscribers
hist(WHO$CellularSubscribers)

# boxplot of life expectancy, sorted by region.
boxplot(WHO$LifeExpectancy ~ WHO$Region)

# Boxplot info :
# => Box shows range between 1st and 3rd quartile, with line marking median
# => Dashed lines at top and bottom show range from minimum and maximum values (excluding outliers)
#    => These are sometime called "whiskers"
# => Outliers are plotted as circles. To calculate whether a point is an outlier:
#    => Calculate the difference between 3rd and 1st quartile -> "Inter-quartile range"
#    => Any point greater than the 3rd quartile, plus the inter-quartile range => Outlier (on top)
#    => Any point less than 1st quartile, minus the inter-quartile range => Outlier (on bottom)

# To add x and ylabels as well as a title, add options as below:
boxplot(WHO$LifeExpectancy ~ WHO$Region, xlab="", ylab="Life Expectancy", main="Life Expectancy of Countries by region")

# Now for some summary tables. This is an overall 
table(WHO$Region)

# This splits the variable Over60 by region, and computes the mean for each.
# 1st argument is the value of interest
# 2nd argument is the filter to split data
# 3rd argument is the function to apply on data
tapply(WHO$Over60, WHO$Region, mean)

# This will take the literacy rate, group by region, and return the minimum across region
tapply(WHO$LiteracyRate, WHO$Region, min) # Returns NA for all regions !

# To redo the above command but filtering out the NA values, add an extra argument
tapply(WHO$LiteracyRate, WHO$Region, min, na.rm=TRUE)

##############################################################################
# VIDEO 7: SAVING WITH SCRIPT FILES
#

# To run sections of a script, highlight the lines and press CMD+Enter
# You can also save the transcript of the commands 


