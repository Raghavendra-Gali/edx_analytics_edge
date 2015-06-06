# WEEK 1 : Assignment 1 (due 16th June 2015)

# Cd into the working directory
setwd("/Users/tim/Dropbox/courses/Analytics Edge/week1/src")

# Load in the data source
IBM = read.csv("IBMStock.csv")
GE = read.csv("GEStock.csv")
ProcterGamble = read.csv("ProcterGambleStock.csv")
CocaCola = read.csv("CocaColaStock.csv")
Boeing = read.csv("BoeingStock.csv")

# Convert dates using the string format below
IBM$Date = as.Date(IBM$Date, "%m/%d/%y")
GE$Date = as.Date(GE$Date, "%m/%d/%y")
CocaCola$Date = as.Date(CocaCola$Date, "%m/%d/%y")
ProcterGamble$Date = as.Date(ProcterGamble$Date, "%m/%d/%y")
Boeing$Date = as.Date(Boeing$Date, "%m/%d/%y")

# Problem 1 section
min(Boeing$Date)
max(Boeing$Date)
mean(IBM$StockPrice)
min(GE$StockPrice)
max(CocaCola$StockPrice)
median(Boeing$StockPrice)
sd(ProcterGamble$StockPrice)

# Problem 2 section
plot(CocaCola$Date, CocaCola$StockPrice, xlab = "Date", ylab = "Stock Price", main = "Coca Cola Stock price", type="l", col="red")
lines(ProcterGamble$Date, ProcterGamble$StockPrice, col="blue")
abline(v=as.Date(c("2000-03-01")), lwd=2)
abline(v=as.Date(c("1983-03-01")), lwd=2)

# Problem 3 section
plot(CocaCola$Date[301:432], CocaCola$StockPrice[301:432], type="l", col="red", ylim=c(0,210))
lines(ProcterGamble$Date[301:432], ProcterGamble$StockPrice[301:432], col="blue")
lines(IBM$Date[301:432], IBM$StockPrice[301:432], col="green")
lines(GE$Date[301:432], GE$StockPrice[301:432], col="purple")
lines(Boeing$Date[301:432], Boeing$StockPrice[301:432], col="orange")
abline(v=as.Date(c("2000-03-01")), lwd=2)
abline(v=as.Date(c("1997-09-01")), lwd=2)
abline(v=as.Date(c("1997-11-01")), lwd=2)

# Problem 4 section
mean(IBM$StockPrice)
tapply(IBM$StockPrice, months(IBM$Date), mean)
tapply(Boeing$StockPrice, months(Boeing$Date), mean)
tapply(ProcterGamble$StockPrice, months(ProcterGamble$Date), mean)

tapply(GE$StockPrice, months(GE$Date), mean)
tapply(CocaCola$StockPrice, months(CocaCola$Date), mean)








