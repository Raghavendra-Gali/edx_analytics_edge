# The Analytics Edge

### EDX Course MITx - 15.071x (Summer 2015)

#### Week 4 (Trees)
This week focused on using CART to build a single tree, or random forests to build a randomised assortment of trees which are then combined to give a single model.

The trees divide the input feature space into splits (for example house prices > 50k), and then within each of those categories, further splits are added. This makes them suitable for non-linear problems.

The parameters used in tree-building are:

* minbucket (CART) or nodesize (random forest) which specifies the minimum amount of examples for a split to be formed.
* Complexity Parameter 'cp', which acts like a regularization parameter to prevent overfitting.

Either method can be used to make a classifier (add method="class" to the rpart invocation) or a regression. For the regression, you can specify a threshold, plot ROC curves and calculate AUC in the same way as a logistic regression.

To search for an optimum value of cp, you can use k-folds cross validation with a grid search of the cp values.

Note: This week, the ClaimsData for the D2Hawkeye example was very large (17MB) so I deleted the csv after I finished. To run this script, just unzip the ClaimsData.csv.zip.

~~~R
# Create a binary CART classifier from training data, predict on testing data and show confusion matrix
CARTb = rpart(isB ~ . - letter, data=lettersTrain, method="class")
CARTbPred = predict(CARTb, newdata = lettersTest, type="class")
table(lettersTest$isB, CARTbPred)

# Create a random forest binary classifier using same data, predict and show confusion matrix
isBForest = randomForest(isB ~ . - letter - isB, data = lettersTrain)
PredictBForest = predict(isBForest, newdata = lettersTest)
table(lettersTest$isB, PredictBForest)

# The two snippets above can be used to predict a multi-class output (may need to convert using as.factor())

# To do Cross-Validation, create a trainingControl object, specifying the method as "cv" for cross-validation, and the number of folds in the k-folds.
tr.control = trainControl(method="cv", number=10)
# Create a vector of cp values to search
cp.grid = expand.grid(.cp = (0:10)*0.001)
#Train the model across the folds and cp values to find the smallest RMSE
tr = train(<dependent variable> ~ <independent variables>,
           data=train, method="rpart", trControl = tr.control, tuneGrid = cp.grid)
# Print out the results of cross-validation, check RMSE
tr

~~~


#### Week 3 (Logistic Regression)
This week covered Logistic Regression, and gave a great overview of how best to set the threshold of the predictor to tune between sensitivity and specificity. The AUC is a metric overall of how well the model performs across a range of thresholds.

There were a few different definitions that I need to memorise. N below is the total number of observations, TP = True Positive, FN = False Negative, etc:

* Accuracy = (TP + TN) / N
* Sensitivity (or True Positive Rate) = TP / (TP + FN)
* Specificity (or True Negative Rate) = TN / (TN / FP)

There were a few sequences of commands that cropped up again and again which I copied below:

~~~R

# Splitting dataset into training and test using 'caTools' library
# Assume the overal dataframe is 'data', Training data %age is 'p'
split = sample.split(data$dependentVariable, SplitRatio = p) 
dataTrain = subset(data, split == TRUE)
dataTest = subset(data, split == FALSE)

# Training the logistic model and predicting with threshold 't'
modelName = glm(dependentVariable ~ independentVariables, family = "binomial", data = train)
testPred = predict(predictTrain, type = "response", newdata = test)
table(test$dependentVariable, testPred > t)

# Calculating AUC using the ROCR library
ROCRpred = prediction(testPred, test$dependentVariable)
as.numeric(performance(ROCRpred, "auc")@y.values)

# Plotting AUC with colour highlighting of thresholds
ROCRperf = performance(ROCRpred, "tpr", "fpr")
plot(ROCRperf, colorize=TRUE, print.cutoffs.at=seq(0,1,0.1), text.adj=c(-0.2,1.7))

~~~


#### Week 2 (Linear Regression)
This week focused on Linear Regression, and had a number of assignments. I didn't complete the optional assigments this week due to time. The course is taking around 6 hours a week according to my Toggl summaries.

The hardest thing about this week's assignment was keeping track of how to calculate SSE, SST, RMSE, and R^2 (see below). The lm() and predict() functions were straightforward to use, and like all R functions so far give a nice summary of the model's performance. 

* SSE (Sum of Squared Errors) : Take the sum of the squared differences between the actual and predicted values.
* SST (Total Sum of Squares) : Disregard all the coefficients of the model apart from the intercept value, and calculate the SSE using this flat line.
* R^2 = 1 - (SSE / SST) : This quantifies how well the coefficients of the independent variables approximate the real data.


#### Week 1 (Introduction to R)

This week's lectures and assignment were an introduction to R and its basic syntax. The assigmnents revolved around loading datasets in CSV format, and finding correlations in the data using the 'table' and 'tapply' commands. Plots were also introduced, with scatter plots, boxplots, and histograms.

I found myself generating a lot of TRUE/FALSE tables for dataframes, and then answering "what is the proportion of x that are TRUE" by manually dividing the required "TRUE" count by the sum of TRUE and FALSE. I wonder if there's a shorthand for that.


