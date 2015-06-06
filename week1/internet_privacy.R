# Assignment 1 : Internet Privacy Poll 
#

# Problem 1 section
setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")

# 1.1 Load in the data source
poll = read.csv("AnonymityPoll.csv")
str(poll)
summary(poll)

# 1.2
table(poll$Smartphone)
summary(poll$Smartphone)

# 1.3 
table(poll$State, poll$Region == "Midwest")
table(poll$State, poll$Region == "South")

# 2.1
table(poll$Internet.Use, poll$Smartphone)

# 2.2
summary(poll$Internet.Use)
summary(poll$Smartphone)

# 2.3
limited = subset(poll, poll$Internet.Use | poll$Smartphone)
str(limited)
summary(limited)

# 3.3
table(limited$Info.On.Internet)

# 3.4
table(limited$Worry.About.Info) # 386 people worry
386/(386+404)

# 3.5
table(limited$Anonymity.Possible) # 475 0, 278 1
278/(278+475)

# 3.6
table(limited$Tried.Masking.Identity)
128/(128+656)

# 3.7
table(limited$Privacy.Laws.Effective)
186/(186+541)

# 4.1
hist(limited$Age)

# 4.2
plot(limited$Age, limited$Info.On.Internet)
table(limited$Age, limited$Info.On.Internet)
tapply(limited$Age, limited$Info.On.Internet, max)

# 4.3
jitter(c(1, 2, 3))
jitter(c(1, 2, 3))
jitter(c(1, 2, 3))
jitter(c(1, 2, 3))

# 4.4
plot(jitter(limited$Age), jitter(limited$Info.On.Internet))

# 4.5
tapply(limited$Info.On.Internet, limited$Smartphone, mean)

# 4.6
tapply(limited$Tried.Masking.Identity, limited$Smartphone, table)

