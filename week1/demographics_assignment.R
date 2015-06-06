# Assignment 1 : Demographics 
#


# Problem 1 section
setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")

# Load in the data source
CPS = read.csv("CPSData.csv")
str(CPS)
summary(CPS)

summary(CPS$Industry)

sort(table(CPS$State))

sort(table(CPS$Citizenship))

summary(CPS$Race)
table(CPS$Race, CPS$Hispanic)

# Problem 2
summary(CPS)

table(CPS$Region, is.na(CPS$Married))
table(CPS$Sex, is.na(CPS$Married))
table(CPS$Age, is.na(CPS$Married))
table(CPS$Citizenship, is.na(CPS$Married))

# 2.5. Need to reverse the order to take the mean for each state in the tapply one
table(is.na(CPS$MetroAreaCode), CPS$State)
sort(tapply(is.na(CPS$MetroAreaCode), CPS$State, mean))

# Problem 3.1 - Read in the dictionaries
MetroAreaMap = read.csv("MetroAreaCodes.csv")
CountryOfBirthMap = read.csv("CountryCodes.csv")
str(MetroAreaMap)
str(CountryOfBirthMap)

# 3.2 Merge the text representations into the overall dataframe
CPS = merge(CPS, MetroAreaMap, by.x="MetroAreaCode", by.y="Code", all.x=TRUE)
str(CPS)
summary(CPS)

# 3.3
sort(table(CPS$MetroArea))

# 3.4 - "Group hispanic voters by metro area, calculate proportion/mean and sort in printout"
sort(tapply(CPS$Hispanic, CPS$MetroArea, mean))

# 3.5 Group Asian race by metro area, calculate proportion, and sort results
sort(tapply(CPS$Race == "Asian", CPS$MetroArea, mean))

# 3.6 
sort(tapply(CPS$Education == "No high school diploma", CPS$MetroArea, mean, na.rm=TRUE), decreasing=TRUE)

# 4.1 Merge in the country-of-birth info. Goes into Country inside CPS dataframe
CPS = merge(CPS, CountryOfBirthMap, by.x="CountryOfBirthCode", by.y="Code", all.x=TRUE)
summary(CPS$Country)

# 4.2
table(CPS$Country, CPS$Region != "NorthAmerica")

# 4.3 3736 from US, 5 NA, Total = 5404 (no NA's) from summary() counting
NYSubset = subset(CPS, MetroArea == "New York-Northern New Jersey-Long Island, NY-NJ-PA", na.rm=TRUE)
table(NYSubset$Country, NYSubset$Country != "United States")

# 4.4 
sort(tapply(CPS$Country == "India", CPS$MetroArea, sum, na.rm=TRUE)) # New York-Northern New Jersey-Long Island, NY-NJ-PA
sort(tapply(CPS$Country == "Brazil", CPS$MetroArea, sum, na.rm=TRUE)) # Boston-Cambridge-Quincy, MA-NH 
sort(tapply(CPS$Country == "Somalia", CPS$MetroArea, sum, na.rm=TRUE)) # Minneapolis-St Paul-Bloomington, MN-WI
