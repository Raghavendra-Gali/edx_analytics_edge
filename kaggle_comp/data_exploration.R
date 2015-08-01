# KAGGLE COMPETITION - DATA EXPLORATION

# Poke about in the data to look for clues, use visualization

#Use ggplot for heatmaps
library(ggplot2)
library(reshape2)

# tim : Extra code to change into the kaggle directory and clear variables
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/kaggle_comp")

# We'll be doing NLP on the descriptions, so don't read strings as factors, and
# convert the actual factors back afterwards

ebay = read.csv("eBayiPadTrain.csv")
ebaySub = read.csv("eBayiPadTest.csv")

str(ebay)
str(ebaySub)

summary(ebay)
summary(ebaySub)

# Interested in biddable vs non biddable. 
ebayNonBiddable = subset(ebay, biddable == FALSE)
ebayBiddable = subset(ebay, biddable == TRUE)



ebayNonBidTable = table(ebayNonBiddable$productline, ebayNonBiddable$sold)
table(ebayBiddable$productline, ebayBiddable$sold)

# For non-biddable: Make a heatmap for each of the product lines vs startprice, fill is # sold
ebayNonBiddableProdVsSold = as.data.frame(table(ebayNonBiddable$productline, ebayNonBiddable$sold))
ggplot(ebayNonBiddableProdVsSold, aes(x = Var1, y = Var2)) + geom_tile(aes(fill=Freq)) + ggtitle("Non biddable: Product line vs Sold")

ebayProdVsSold = as.data.frame(table(ebay$productline, ebay$sold))
ggplot(ebayProdVsSold, aes(x = Var1, y = Var2)) + geom_tile(aes(fill=Freq)) + ggtitle("Non biddable: Product line vs Sold")


# tapply(ebayNonBiddable$sold, ebayNonBiddable$productline, sum)

# What is the distribution of product line like in the training and test data?
ggplot(data = ebay, aes(x = productline)) + geom_histogram() + ggtitle("ebay: Productline histogram")
ggplot(data = ebaySub, aes(x = productline)) + geom_histogram() + ggtitle("ebaySub: Productline histogram")

table(ebay$productline, ebay$storage)


# For non biddable, plot the sold prices for each of the product lines
ebayNonBiddableIpad2 = subset(ebayNonBiddable, productline == "iPad 2")
table(ebayNonBiddableIpad2$startprice, ebayNonBiddableIpad2$sold)
plot(ebayNonBiddableIpad2$startprice, ebayNonBiddableIpad2$sold)


# Check the variation of price with storage

plot()
hist(subset(ebayNonBiddable, sold == 1)$startprice )


ebayNonBiddableMelt = melt(ebayNonBiddable, sold)
ggplot(ebayNonBiddable, aes(startprice)) + 
  geom_bar(aes(fill = sold), position = "dodge")


boxplot(ebayNonBiddable$productline, ebayNonBiddable$startprice)

cor(ebayNonBiddable$sold, ebayNonBiddable$startprice)
table(ebay$productline)

ebaySold = subset(ebay, sold == TRUE)
