##############################################################################
# WEEK 5 - Text Analytics - Assignment - Wikipedia vandalism checker

#tm is the text mapping library used for analytics
library(tm)

# SnowballC is also needed for NLP
library(SnowballC)

# caTools used for the sampel.split() function 
library(caTools)

# CART model and plotting libraries
library(rpart)
library(rpart.plot)

# Random Forests are used later in the assignment
library(randomForest)

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week5")
emails = read.csv("emails.csv", stringsAsFactors = FALSE)
summary(emails)
str(emails)

# The dataset just contains the following variables
# text : The text of the email
# spam : Binary value with 1 = spam, 0 = not spam

# 1.2
str(subset(emails, spam == TRUE))

# 1.5
tempEmails = emails
tempEmails$count = length(emails$text)
subset(tempEmails, nchar(tempEmails$text) == 13)


# 2.1

# Pepare the corpus, including all pre-processing
corpus = Corpus(VectorSource(emails$text))
corpus = tm_map(corpus, tolower)
corpus = tm_map(corpus, PlainTextDocument)
corpus = tm_map(corpus, removePunctuation)
corpus = tm_map(corpus, removeWords, stopwords("english"))
corpus = tm_map(corpus, stemDocument)

# Create Document Term Matrices for Title and Abstract, print out how many words
dtm    = DocumentTermMatrix(corpus)
dtm

# 2.2
# Limit the words to those in at least 95% of docs
spdtm    = removeSparseTerms(dtm, 0.95)
spdtm

# 2.3
# Convert DTM to dataframe
emailsSparse    = as.data.frame(as.matrix(spdtm))

# Prefix column names starting with numbers with a letter to make them valid
colnames(emailsSparse) = make.names(colnames(emailsSparse))
# str(emailsSparse)
sort(colSums(emailsSparse))

# 2.4 

# Add the dependent variable into the sparsified corpus dataframe
emailsSparse$spam = emails$spam
emailsHam = subset(emailsSparse, emailsSparse$spam == FALSE)
emailsSpam = subset(emailsSparse, emailsSparse$spam == TRUE)
sort(colSums(emailsHam))

# 2.5
sort(colSums(emailsSpam))

# 3.1
# Need to conver the dependent variable to a factor for classification
emailsSparse$spam = as.factor(emailsSparse$spam)

set.seed(123)
split = sample.split(emailsSparse$spam, SplitRatio = 0.7)
train = subset(emailsSparse, split == TRUE)
test = subset(emailsSparse, split == FALSE)

# Logistic regression
spamLog = glm(spam ~ . , data = train, family="binomial")
spamLogPred = predict(spamLog, newdata = train, type="response")

# CART. Can use method="class" in rpart and type="class" in predict 
# if you don't need AUC and probabilities, and need a non-0.5 threshold
spamCART = rpart(spam ~ . , data = train)
spamCARTPred = predict(spamCART, newdata = train)
spamCARTPred = spamCARTPred[,2]

# Random Forest. Need to use type="prob" here to get the probabilities, so we
# can set the threshold at 0.5 and calcualte AUC
set.seed(123)
spamRF = randomForest(spam ~ . , data = train, type = "prob")
spamRFPred = predict(spamRF, newdata = train, type = "prob")
spamRFPred = spamRFPred[,2]

# Evaluate the models
table(spamLogPred < 0.00001)
table(spamLogPred > 0.99999)
table(spamLogPred > 0.00001, spamLogPred < 0.99999)

# 3.2
summary(spamLog)

# 3.3
prp(spamCART)

# 3.4 Accuracy of Log Reg
table(train$spam, spamLogPred > 0.5)
(3052+954)/nrow(train)

# 3.5 Check the AUC of the model using ROCR
predROCR = prediction(spamLogPred, train$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
as.numeric(performance(predROCR, "auc")@y.values)

# 3.6 spamCARTPred accuracy (0.942394)
table(train$spam, spamCARTPred )
(2885+894)/nrow(train)

# 3.7 spamCRT AUC on training set (0.9696044)
predROCR = prediction(spamCARTPred, train$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values

# 3.8 Accuracy of spamRF (threshold of 0.5) = 0.9985037
table(train$spam, spamRFPred > 0.5)
(3046+958)/nrow(train)

# 3.9 AUC of random forest model = (0.9999959)
predROCR = prediction(spamRFPred, train$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values

# 3.10
# Evaluation of all models
# Model         : Accuracy      : AUC
# Log Reg       : 0.9990025     : 0.9999959 <- BEST overall
# CART          : 0.942394      : 0.9696044
# Random Forest : 0.9985037     : 0.9999959

# 4.1 Logistic regression accuracy on test set = 0.9505239
spamLogPred = predict(spamLog, newdata = test, type="response")
table(test$spam, spamLogPred> 0.5)
(1257+376)/nrow(test)

# 4.2 AUC of Log Reg using test set = 0.9627517
predROCR = prediction(spamLogPred, test$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values

# Test Set accuracy of spamCART = 0.9394645
spamCARTPred = predict(spamCART, newdata = test)
spamCARTPred = spamCARTPred[,2]
table(test$spam, spamCARTPred > 0.5)
(1228+386)/nrow(test)

# Test Set AUC of spamCART = 0.963176
predROCR = prediction(spamCARTPred, test$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values

# Test Set accuracy of random Forest = 0.9749709
spamRFPred = predict(spamRF, newdata = test, type = "prob")
spamRFPred = spamRFPred[,2]
table(test$spam, spamRFPred > 0.5)
(1290+385)/nrow(test)

# Test Set AUC of Random Forest = 0.9975656
predROCR = prediction(spamRFPred, test$spam)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
performance(predROCR, "auc")@y.values

# 4.7
# Evaluation of all models
# Model         : Accuracy      : AUC
# Log Reg       : 0.9505239     : 0.9627517
# CART          : 0.9394645     : 0.963176
# Random Forest : 0.9749709     : 0.9975656

