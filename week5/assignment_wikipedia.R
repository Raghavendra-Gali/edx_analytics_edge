##############################################################################
# WEEK 5 - Text Analytics - Assignment - Wikipedia vandalism checker

#tm is the text mapping library used for analytics
library(tm)

# SnowballC is also needed for NLP
library(SnowballC)

# caTools used for the sampel.split() function 
library(caTools)


# Uncomment to clear workspace on every run
rm(list=ls())

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week5")

# Dataframe fields are below:
# Vandal = 1 if this edit was vandalism, 0 if not.
# Minor = 1 if the user marked this edit as a "minor edit", 0 if not.
# Loggedin = 1 if the user made this edit while using a Wikipedia account, 0 if they did not.
# Added = The unique words added.
# Removed = The unique words removed.

# Load the CSV, remember stringsAsFactors FALSE for NLP tasks.
# Also convert the Vandal column to factors
wiki= read.csv("wiki.csv", stringsAsFactors = FALSE)
wiki$Vandal = as.factor(wiki$Vandal)
summary(wiki)

# 1.1
table(wiki$Vandal)

# 1.2

# Create corpus for the Added terms
corpusAdded = Corpus(VectorSource(wiki$Added))
corpusAdded[[1]]$content

# Remove english stopwords, check first entry
corpusAdded = tm_map(corpusAdded, removeWords, stopwords("english"))
corpusAdded[[1]]$content

# Now stem the document, removing endings of words
corpusAdded = tm_map(corpusAdded, stemDocument)
corpusAdded[[1]]$content

# Build DocumentTermMatrix from the corpus so far
dtmAdded = DocumentTermMatrix(corpusAdded)
dtmAdded # Has 6675 terms, in 3786 docs

# 1.3 Remove terms which only appear in 0.3% or more revisions
sparseAdded = removeSparseTerms(dtmAdded, 0.997)
sparseAdded # Now has 166 terms instead of 6675

# Convert the sparseAdded matrix to a dataframe called WordsAdded
wordsAdded = as.data.frame(as.matrix(sparseAdded))

# 1.4
colnames(wordsAdded) = paste("A", colnames(wordsAdded))


# Repeat the above but for the removed terms 
corpusRemoved = Corpus(VectorSource(wiki$Removed))
corpusRemoved = tm_map(corpusRemoved, removeWords, stopwords("english"))
corpusRemoved = tm_map(corpusRemoved, stemDocument)
dtmRemoved    = DocumentTermMatrix(corpusRemoved)
sparseRemoved = removeSparseTerms(dtmRemoved, 0.997)
wordsRemoved  = as.data.frame(as.matrix(sparseRemoved))

# 1.4
colnames(wordsRemoved) = paste("A", colnames(wordsRemoved))
wordsRemoved

# 1.5
wikiWords = cbind(wordsAdded, wordsRemoved)
wikiWords$Vandal = wiki$Vandal
summary(wikiWords)

set.seed(123)
split = sample.split(wikiWords$Vandal, SplitRatio = 0.7)
wikiWordsTrain = subset(wikiWords, split == TRUE)
wikiWordsTest = subset(wikiWords, split == FALSE)

# Calculate accuracy (0.5313844)
table(wikiWordsTest$Vandal)
(618)/nrow(wikiWordsTest)

# 1.6
wikiCART = rpart(Vandal ~ . , data=wikiWordsTrain)
wikiPred = predict(wikiCART, newdata = wikiWordsTest, type="class") # threshold 0.5
table(wikiWordsTest$Vandal, wikiPred)

# Accuracy (0.5417025)
(618+12)/nrow(wikiWordsTest)

# 1.7
prp(wikiCART)


# 2.0

# Add a new column to show if a web address was added to the record
wikiWords2 = wikiWords
wikiWords2$HTTP = ifelse(grepl("http",wiki$Added,fixed=TRUE), 1, 0)
table(wikiWords2$HTTP)

# 2.1 Generate a new CART model using the presence of http in the extra
#     words to help the model out
wikiTrain2 = subset(wikiWords2, split==TRUE)
wikiTest2 = subset(wikiWords2, split==FALSE)

wikiCART2 = rpart(Vandal ~ . , data=wikiTrain2)
wikiPred2 = predict(wikiCART2, newdata = wikiTest2, type="class") # threshold 0.5
table(wikiTest2$Vandal, wikiPred2)

# New CART2 accuracy (0.5417025)
(609+57)/nrow(wikiTest2)

# 2.3 Check to see if the amount of words added/removed helps model

wikiWords2$NumWordsAdded = rowSums(as.matrix(dtmAdded))
wikiWords2$NumWordsRemoved = rowSums(as.matrix(dtmRemoved))

summary(wikiWords2)


# 2.4 Redo the model using the # words added and removed too
wikiTrain2 = subset(wikiWords2, split==TRUE)
wikiTest2 = subset(wikiWords2, split==FALSE)

wikiCART2 = rpart(Vandal ~ . , data=wikiTrain2)
wikiPred2 = predict(wikiCART2, newdata = wikiTest2, type="class") # threshold 0.5
table(wikiTest2$Vandal, wikiPred2)

# New CART2 accuracy (0.6552021)
(514+248)/nrow(wikiTest2)

# 3.1 Getting meta on the meta for the matter at hand.

# Now add in some information about whether the change was minor, and 
# whether the user was logged in
wikiWords3 = wikiWords2
wikiWords3$Minor = wiki$Minor
wikiWords3$Loggedin = wiki$Loggedin

wikiTrain3 = subset(wikiWords3, split==TRUE)
wikiTest3 = subset(wikiWords3, split==FALSE)

wikiCART3 = rpart(Vandal ~ . , data=wikiTrain3)
wikiPred3 = predict(wikiCART3, newdata = wikiTest3, type="class") # threshold 0.5
table(wikiTest3$Vandal, wikiPred3)

# Accuracy of the new model (0.7188306)
(595+241)/nrow(wikiTest3)

# 3.2 The accuracy improved a lot ! Check the tree to see why
prp(wikiCART3)

