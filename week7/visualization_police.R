# KAGGLE COMPETITION - GETTING STARTED

# Need the ggplot2 library for fancy plots
library(ggplot2)

# Need these libraries to plot on the maps
library(maps)
library(ggmap)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

# VIDEO 3: A LINE PLOT

# Need to read the text field as text, not categories
# 191641 observations of 3 variables
mvt = read.csv("mvt.csv", stringsAsFactors = FALSE)
str(mvt)

# Need to convert the dates using a formatting string. The current format is:
# "mm/dd/yy hh:mm" changes to POSIXlt afterwards
mvt$Date = strptime(mvt$Date, format="%m/%d/%y %H:%M")
str(mvt)

# Pull out the date and hour into their own variables
mvt$Weekday = weekdays(mvt$Date)
mvt$Hour = mvt$Date$hour
str(mvt)


# Now create a line plot for the weekly crimes on the day of the week
# Need to convert the table output to a data frame first:
# Var1 : Day of week, Freq = # crimes on that day
WeekdayCounts = as.data.frame(table(mvt$Weekday))
str(WeekdayCounts)

# Now we can do a line plot. the group = 1 groups the data
# This line pot comes out with the days (Var1) ordered alphabetically !
# Need to change it to a categorical value with an explicit order
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1))

# Use the factor function to convert Var1 to the weekdays
WeekdayCounts$Var1 = factor(WeekdayCounts$Var1, ordered=TRUE, 
                            levels=c("Monday", "Tuesday", "Wednesday", 
                                     "Thursday", "Friday", "Saturday", 
                                     "Sunday"))

# Looks good ! But the x and y labels aren't very useful
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1))


# Add labels to the plot
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1)) + xlab("Day of the week") + ylab("Total Motor Vehicle Thefts")

line <- readline()

# QUICK QUESTION

# This makes the lines dashed
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), linetype=2) + xlab("Day of the week") + ylab("Total Motor Vehicle Thefts")

# This makes the line more transparent (alpha)
ggplot(WeekdayCounts, aes(x = Var1, y = Freq)) + geom_line(aes(group=1), alpha=0.3) + xlab("Day of the week") + ylab("Total Motor Vehicle Thefts")

# VIDEO 4: A HEATMAP

# Now add the hour of the day to the plot, and use a heatmap

# Start by grouping the hours by day, and checking how many crimes occured
table(mvt$Weekday, mvt$Hour)

# Save the table to a dataframe for visualization
# 168 observations (24 hours x 7 days)
# Var1 = Day of the week
# Var2 = Hour of the day
# Freq = Amount of crimes
DayHourCounts = as.data.frame(table(mvt$Weekday, mvt$Hour))
str(DayHourCounts)

# Convert the hour to a numeric data type, instead of categorical
DayHourCounts$Hour = as.numeric(as.character((DayHourCounts$Var2)))

# Now ready to plot! 
# This plots 7 lines, one for each day of the week. 
ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group=Var1))

# Add a colour to distinguish days of the week too, and thicker lines
ggplot(DayHourCounts, aes(x = Hour, y = Freq)) + geom_line(aes(group=Var1, color=Var1, size=2))

# Use a heatmap instead to visualize this data.
# We need to convert the order of days so they are in chronological order
DayHourCounts$Var1 = factor(DayHourCounts$Var1, 
                            ordered=TRUE, 
                            levels = c("Monday", "Tuesday", "Wednesday", 
                                       "Thursday", "Friday", "Saturday", 
                                      "Sunday"))

# Now make the heatmap
str(DayHourCounts)
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill=Freq))

# Remove the y label, and label the colours
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill=Freq)) + scale_fill_gradient(name="Total MV Thefts") + theme(axis.title.y = element_blank())


# Now remap the colors of the heatmap with white = low, red = high
ggplot(DayHourCounts, aes(x = Hour, y = Var1)) + geom_tile(aes(fill=Freq)) + scale_fill_gradient(name="Total MV Thefts", low="white", high="red") + theme(axis.title.y = element_blank())

# VIDEO 5: A GEOGRAPHICAL HOT SPOT MAP

# This video plots crime on a map of Chicago

# Load the map of Chicago
chicago = get_map(location = "chicago", zoom=11)
ggmap(chicago)

# plot all the motor vehicle thefts on the map
ggmap(chicago) + geom_point(data=mvt[1:100,], aes(x = Longitude, y = Latitude))


# Round all the lat/lon data to 2 digites of accuracy to group points
LatLonCounts = as.data.frame(table(round(mvt$Longitude, 2), round(mvt$Latitude, 2)))

# Check dataframe structure
# Var1 is Longitude, Var2 is Latitude, , Freq is how many thefts in that area
str(LatLonCounts)

# Convert factor variable to a numeric variable (for Longitude)
LatLonCounts$Long = as.numeric(as.character(LatLonCounts$Var1))
LatLonCounts$Lat = as.numeric(as.character(LatLonCounts$Var2))

# now plot on the map, making the size of the point proportional to the
# number of thefts in that area
ggmap(chicago) + geom_point(data=LatLonCounts, aes(x = Long, y = Lat, color = Freq, size = Freq))

# Looks nice, change color scheme to help see hotspots
ggmap(chicago) + geom_point(data=LatLonCounts, aes(x = Long, y = Lat, color = Freq, size = Freq)) + scale_color_gradient(low="yellow", high="red")

# Can also display a heatmap over the map using geom_tile
# This shows areas in red where more crimes happen
ggmap(chicago) + geom_tile(data=LatLonCounts, aes(x = Long, y = Lat, alpha = Freq), fill = "red")

# QUICK QUESTION
LatLonCounts2 = subset(LatLonCounts, Freq > 0)
nrow(LatLonCounts) - nrow(LatLonCounts2)
ggmap(chicago) + geom_tile(data=LatLonCounts2, aes(x = Long, y = Lat, alpha=Freq), fill="red")

# VIDEO 6: A HEATMAP ON THE UNITED STATES

# Read in the murders dataset for the US
murders = read.csv("murders.csv")
str(murders)
# 51 observations (50 states and Washington DC)

# There's a built in map of the US (in polygon form)
statesMap = map_data("state")
str(statesMap)

# Plot the map of the US with white fill, and lines in black
ggplot(statesMap, aes(x=long,y=lat, group=group)) + geom_polygon(fill="white", color="black")

# Now need to make sure the states in the murders data frame and in the 
# map match up. Create a new variable called region in the murders data
murders$region = tolower(murders$State)

# Now join both data frames, using the region to link records
murderMap = merge(statesMap, murders, by="region")
str(murderMap)

# Now plot the number of murders on the US map
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=Murders)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# CA and TX have a lot of murders, but is that because the are the most populous?
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=Population)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# Need to plot the murder rate per person, not just overall number
murderMap$MurderRate = murderMap$Murders/murderMap$Population*100000
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")

# DC is skewing the results, because it is so small and has a high rate (~20)
# So set limits of the murder rate value manually
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=MurderRate)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend", limits = c(0,10))

# QUICK QUESTION
ggplot(murderMap, aes(x=long, y=lat, group=group, fill=GunOwnership)) + geom_polygon(color="black") + scale_fill_gradient(low="black", high="red", guide="legend")
sort(tapply(murderMap$GunOwnership, murderMap$region, max))


