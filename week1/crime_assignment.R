# WEEK 1 : Assignment 1 (due 16th June 2015)

# Cd into the working directory
setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")

# Load in the data source
mvt = read.csv("mvtWeek1.csv")

# Print our some summaries
str(mvt)
summary(mvt)

# Date handling

# Print out the first date in the records
mvt$Date[1]

# Convert dates using supplied function, check summary
DateConvert = as.Date(strptime(mvt$Date, "%m/%d/%y %H:%M"))
summary(DateConvert)

# Convert the month and day of week
mvt$Month = months(DateConvert)
mvt$Weekday = weekdays(DateConvert)
mvt$Date = DateConvert

# Q: In which month did the fewest motor vehicle thefts occur?
table(mvt$Weekday)

# Q 2.5: Which month has the largest number of motor vehicle thefts for which an arrest was made?
table(mvt$Month, mvt$Arrest)

# Q 3.1: 
hist(mvt$Date, breaks=100)

#Q3.2:
table(mvt$Arrest, mvt$Year)
boxplot(mvt$Date, mvt$Arrest) # ? Can't make head or tail of this boxplot

#Q3.3 - 3.5:
summary(subset(mvt, Year == 2001))
summary(subset(mvt, Year == 2007))
summary(subset(mvt, Year == 2012))

#Q4.1
sort(table(mvt$LocationDescription))

#Q4.2
Top5 = subset(mvt, LocationDescription == "STREET" | LocationDescription == "PARKING LOT/GARAGE(NON.RESID.)" | LocationDescription == "ALLEY" | LocationDescription == "GAS STATION" | LocationDescription == "DRIVEWAY - RESIDENTIAL")
str(Top5)

#Q4.3
Top5$LocationDescription = factor(Top5$LocationDescription)
table(Top5$LocationDescription, Top5$Arrest)

GasStations = subset(Top5, LocationDescription == "GAS STATION")
table(GasStations$Weekday, GasStations$Arrest)

Driveways = subset(Top5, LocationDescription == "DRIVEWAY - RESIDENTIAL")
table(Driveways$Weekday, Driveways$Arrest)

