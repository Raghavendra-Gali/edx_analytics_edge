# VISUALIZATION - Recitation : Good Bad and Ugly

# Need the ggplot2 library for fancy plots
library(ggplot2)

# Use the ggmap package for the world student plot
library(ggmap)

# Need to reshape the data in the family plot
library(reshape2)

# Change into the directory and load data
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

# VIDEO 3: BAR CHARTS IN R

intl = read.csv("intl.csv")
str(intl)
 
# Structure is a Region, and the percent of students from that region

# Make bar plot. stat="identity" means use the value of y variable directly
ggplot(intl, aes(x=Region, y=PercentOfIntl)) + geom_bar(stat="identity") + geom_text(aes(label=PercentOfIntl))

# Ugh, numbers on top of bars not legible, regions overlap, bars look grey and boring
# Also x axis is out of order, just alphabetic

# Re-order the regions in decreasing order of PercentOfIntl
str(intl) # Before
intl = transform(intl, Region = reorder(Region, -PercentOfIntl))
str(intl) # After

# now adjust percentages to be between 0 and 100, instead of 0 and 1
intl$PercentOfIntl = intl$PercentOfIntl * 100

# Fix all the problems:
# Text overlaying looks bad with bunched up text, fix it
# When breaking over lines, put a + at the end so R knows the line continues
# - Change the bar colours to be dark blue
# - Put numbers between 0 and 100
# - vjust is an adjustment to the bar text
# - Remove 'Region' label as it's obvious, and rotate text slightly so they fit
ggplot(intl, aes(x=Region, y=PercentOfIntl)) +
  geom_bar(stat="identity", fill="dark blue") +
  geom_text(aes(label=PercentOfIntl), vjust=-0.4) +
  ylab("Percent of International Students") +
  theme(axis.title.x = element_blank(), axis.text = element_text(angle=45, hjust=1))
  
# VIDEO 5: WORLD MAPS IN R

# Plot a world map using the international student data

# head shows the first few observations in the data frame
intlall = read.csv("intlall.csv", stringsAsFactors = FALSE)
head(intlall)
# Data structure uses UG = UnderGrad, G = Grad

# There are quite a few NA's in the dataframe, these should be 0s.
intlall[is.na(intlall)] = 0
head(intlall)

# Now load the world map
world_map = map_data("world")
str(world_map)

# Combine the world map and intlall dataframes into one frame
world_map = merge(world_map, intlall, by.x="region", by.y="Citizenship")
str(world_map)

# Plot the world map using geom_polygon
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_map("mercator")

# Looks a bit mangled ! the lon and lat values are the points that
# define the border of a country. So if you re-order the points
# they won't be drawn correctly.
# Need to re-order the data by group, and then by order.
world_map = world_map[order(world_map$group, world_map$order),]
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(fill="white", color="black") +
  coord_map("mercator")

# Looks much better ! But some countries are still missing :-(
# USA is missing (students from the USA don't count as international)
# Russia, China, etc missing, but there are students from there.

# To see how the Countries are referred to in the map and dataframe:
table(intlall$Citizenship) # => 'China (People's Republic Of)'

# So change the MIT dataframe to match
intlall$Citizenship[intlall$Citizenship == "China (People's Republic Of)"] = "China"
table(intlall$Citizenship) # => 'China'

# Now re-merge the data again, and re-order
world_map = merge(map_data("world"), intlall, by.x="region", by.y="Citizenship")
world_map = world_map[order(world_map$group, world_map$order),]

# Now try plotting again
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Total), color="black") +
  coord_map("mercator")

# # Extra bit of work to check why Russia isn't turning up
# table(intlall$Citizenship) # => 'Russia'
# table(map_data("world")$region) # => 'USSR'
# 
# # Change from Russia to USSR in the intlall dataframe, re-merge and plot
# intlall$Citizenship[intlall$Citizenship == "Russia"] = "USSR"
# world_map = merge(map_data("world"), intlall, by.x="region", by.y="Citizenship")
# world_map = world_map[order(world_map$group, world_map$order),]
# ggplot(world_map, aes(x=long, y=lat, group=group)) +
#   geom_polygon(aes(fill=Total), color="black") +
#   coord_map("mercator")

# You can also view this in 3d, instead of a mercator projection
# The orientation specifies the lat and lon of the globe.
# This one is centered on Auckland, NZ
ggplot(world_map, aes(x=long, y=lat, group=group)) +
  geom_polygon(aes(fill=Total), color="black") +
  coord_map("ortho", orientation = c(-37,175,0))

# VIDEO 7: USING LINE CHARTS INSTEAD

households = read.csv("households.csv")
str(households)

# 8 observations of 7 vars
# ggplot needs the data in the form: year group fraction
# To do this, we need the melt function from reshape2 library
households[,1:2]

# This command moves the 'MarriedWChild' column name into the actual data
# itself, along with the year and value on the same line.
head(melt(households, id="Year"))

# There are 8 values of MarriedWChild, and 2 values of MarriedWOChild
# which can be used by ggplot
melt(households, id="Year")[1:10,]

# MarriedWChild is decreasing very rapidly ! Couldn't see this from 
# the other stacked bar graph 
ggplot(melt(households, id="Year"), aes(x=Year, y=value, color=variable)) +
  geom_line(size=2) +
  geom_point(size=5) +
  ylab("Percentage of households")


