# The Analytics Edge

### EDX Course MITx - 15.071x (Summer 2015)

#### Week 2
This week focused on Linear Regression, and had a number of assignments. I didn't complete the optional assigments this week due to time. The course is taking around 6 hours a week according to my Toggl summaries.

The hardest thing about this week's assignment was keeping track of how to calculate SSE, SST, RMSE, and R^2 (see below). The lm() and predict() functions were straightforward to use, and like all R functions so far give a nice summary of the model's performance. 

* SSE (Sum of Squared Errors) : Take the sum of the squared differences between the actual and predicted values.
* SST (Total Sum of Squares) : Disregard all the coefficients of the model apart from the intercept value, and calculate the SSE using this flat line.
* R^2 = 1 - (SSE / SST) : This quantifies how well the coefficients of the independent variables approximate the real data.


#### Week 1

This week's lectures and assignment were an introduction to R and its basic syntax. The assigmnents revolved around loading datasets in CSV format, and finding correlations in the data using the 'table' and 'tapply' commands. Plots were also introduced, with scatter plots, boxplots, and histograms.

I found myself generating a lot of TRUE/FALSE tables for dataframes, and then answering "what is the proportion of x that are TRUE" by manually dividing the required "TRUE" count by the sum of TRUE and FALSE. I wonder if there's a shorthand for that.


