##############################################################################
# WEEK 3 - Logistic Regression - Assignment - Songs
#

# Uncomment to clear workspace on every run
rm(list=ls())

setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week3")
songs = read.csv("songs.csv")
str(songs)

# Q1.1
songs2010 = subset(songs, year == 2010)
str(songs2010)

# Q1.2
songsMJ = subset(songs, artistname == "Michael Jackson")
str(songsMJ)

#Q1.3
songsMJTopTen = subset(songsMJ, Top10 == 1)
songsMJTopTen$songtitle

#Q1.4
table(songs$timesignature)

#Q1.5
sort(tapply(songs$tempo, songs$songtitle, max))

#Q2.1 - Split data into training and test sets
SongsTrain = subset(songs, year <= 2009)
SongsTest = subset(songs, year > 2009)

str(SongsTrain)
str(SongsTest)

# Q2.2 predicting TopTen value.
# Want to use all numeric independent values initially, but there are some 
# categorical ones that need to be dropped.
nonvars = c("year", "songtitle", "artistname", "songID", "artistID")
SongsTrain = SongsTrain[ , !(names(SongsTrain) %in% nonvars) ]
SongsTest = SongsTest[ , !(names(SongsTest) %in% nonvars) ]

# Now the training and test data contains only numeric data for the model
model1 = glm(Top10 ~ . , data = SongsTrain, family = binomial)
summary(model1)

# Q3.1
cor(SongsTrain$loudness, SongsTrain$energy)

# Q3.2
# Subtracting is a quick way to remove a numeric category from the model
# but it won't work on categorical values
SongsLog2 = glm(Top10 ~ . - loudness, data=SongsTrain, family=binomial)
summary(SongsLog2)

# Q3.3
# Subtracting is a quick way to remove a numeric category from the model
# but it won't work on categorical values
SongsLog3 = glm(Top10 ~ . - energy, data=SongsTrain, family=binomial)
summary(SongsLog3)

# Q4.1
model3Pred = predict(SongsLog3, type="response", newdata = SongsTest)
table(SongsTest$Top10, model3Pred > 0.45)

# Compute accuracy of model 3 - 88%
(309+19) / (309+5+40+19)

# Q4.2 - Compute baseline accuracy based on average case
table(SongsTest$Top10) # 314 non-Top10, 59 Top10 records

# Accuracy of predicting most common case - 84%
314 / (314 + 59)

# Sensitivity = TP / (TP + FN)
19 / (19 + 40)

# Specificity = TN / (TN + FP)
309 / (309 + 5)
