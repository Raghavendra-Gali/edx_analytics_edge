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

# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week5")
trials = read.csv("clinical_trial.csv", stringsAsFactors = FALSE)
summary(trials)

# Dataset variables:
# title: Titles of publication
# abstract: Abstract summary of the publication
# trial: Clinical trial testing a drug for cancer

sortedTrials = sort(nchar(trials$abstract), decreasing = TRUE)
sortedTrials[1:10]

# 1.2 Check how many publications have an abstract with 0 words
noAbstract = subset(trials, abstract == "")
str(noAbstract)

# 1.3
sortedTitles = sort(nchar(trials$title), decreasing = FALSE)
sortedTitles[1:10]
shortestTitle = subset(trials, nchar(trials$title) == 28)

# 2.1

# Create the corpus variables
corpusTitle    = Corpus(VectorSource(trials$title))
corpusAbstract = Corpus(VectorSource(trials$abstract))

# Convert both to lowercase
corpusTitle    = tm_map(corpusTitle, tolower)
corpusAbstract = tm_map(corpusAbstract, tolower)

# Extra step needed by the problem to convert to PlainTextDocument
corpusTitle    = tm_map(corpusTitle, PlainTextDocument)
corpusAbstract = tm_map(corpusAbstract, PlainTextDocument)

# Remove the punctuation
corpusTitle    = tm_map(corpusTitle, removePunctuation)
corpusAbstract = tm_map(corpusAbstract, removePunctuation)

# Remove stopwords
corpusTitle    = tm_map(corpusTitle, removeWords, stopwords("english"))
corpusAbstract = tm_map(corpusAbstract, removeWords, stopwords("english"))

# Remove word endings (stem) the document
corpusTitle    = tm_map(corpusTitle, stemDocument)
corpusAbstract = tm_map(corpusAbstract, stemDocument)

# Create Document Term Matrices for Title and Abstract, print out how many words
dtmTitle    = DocumentTermMatrix(corpusTitle)
dtmAbstract = DocumentTermMatrix(corpusAbstract)
dtmTitle
dtmAbstract

# Limit the words to those in at least 95% of docs
dtmTitle    = removeSparseTerms(dtmTitle, 0.95)
dtmAbstract = removeSparseTerms(dtmAbstract, 0.95)
dtmTitle
dtmAbstract

# Convert both the DTM's to matrices
dtmTitle    = as.data.frame(as.matrix(dtmTitle))
dtmAbstract = as.data.frame(as.matrix(dtmAbstract))

# 2.3
# summary(dtmAbstract)
sort(colSums(dtmAbstract))

# 3.1
colnames(dtmTitle) = paste0("T", colnames(dtmTitle))
colnames(dtmAbstract) = paste0("A", colnames(dtmAbstract))
sort(colSums(dtmAbstract))

# 3.2
dtm = cbind(dtmTitle, dtmAbstract)
dtm$trial = trials$trial

# 3.3
set.seed(144)
split = sample.split(dtm$trial, SplitRatio = 0.7)
train = subset(dtm, split == TRUE)
test = subset(dtm, split == FALSE)

# Check baseline accuracy
table(train$trial)
730/(730+572)

# 3.4 Build CART model
trialCART = rpart(trial ~ . , data = train, method="class")
prp(trialCART)

# 3.5 
predCART = predict(trialCART, newdata = train)
predCART2ndCol = predCART[,2]
# summary(predCART2ndCol)

# 3.7 Set threshold to 0.5, compute accuracy, sensitivity, specificity
t = 0.5 
table(train$trial, predCART2ndCol > t)

# Accuracy (0.8233487)
(631+441)/nrow(train)

# Sensitivity (TPR)
(441)/(441+131)

# Specificity (TNR)
(631)/(631+99)

# 4.1 Test set accuracy ()
t = 0.5
predCART = predict(trialCART, newdata = test)
predCART = predCART[,2]
table(test$trial, predCART > t)

(261+162)/nrow(test)

# 4.2 Check the AUC of the model using ROCR
predROCR = prediction(predCART, test$trial)
perfROCR = performance(predROCR, "tpr", "fpr")
plot(perfROCR, colorize=TRUE)
as.numeric(performance(predROCR, "auc")@y.values)


