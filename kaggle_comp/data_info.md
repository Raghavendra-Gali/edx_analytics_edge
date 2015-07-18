# File descriptions

The data provided for this competition is split into two files:

- eBayiPadTrain.csv = the training data set. It consists of 1861 listings.
- eBayiPadTest.csv = the testing data set. It consists of 798 listings. 

We have also provided a sample submission file, SampleSubmission.csv. This file gives an example of the format of submission files (see the Evaluation page for more information). The data for this competition comes from eBay.com.

## Data fields

The dependent variable in this problem is the variable sold, which labels if an iPad listed on the eBay site was sold (equal to 1 if it did, and 0 if it did not). The dependent variable is provided in the training data set, but not the testing dataset. This is an important difference from what you are used to - you will not be able to see how well your model does on the test set until you make a submission on Kaggle.

The independent variables consist of 9 pieces of product data available at the time the iPad listing is posted, and a unique identifier:

- **description** : The text description of the product provided by the seller.
- **biddable** : Whether this is an auction (biddable=1) or a sale with a fixed price (biddable=0).
- **startprice** : The start price (in US Dollars) for the auction (if biddable=1) or the sale price (if biddable=0).
- **condition** : The condition of the product (new, used, etc.)
- **cellular** : Whether the iPad has cellular connectivity (cellular=1) or not (cellular=0).
- **carrier** : The cellular carrier for which the iPad is equipped (if cellular=1); listed as "None" if cellular=0.
- **color** : The color of the iPad.
- **storage** : The iPad's storage capacity (in gigabytes).
- **productline** : The name of the product being sold.
- **sold** : Whether the device was sold or not (*dependent var*)

## Notes
Ideas to improve results

- Can you impute the sold variable on the test set and use that to increase the amount of observations?
- Tune the threshold?


## Results

### logistic_regression

Logistic Regression model using biddable, startprice, condition, cellular, carrier, color, storage, productline. Threshold 0.5.

- Accuracy : 0.7943787
- **AUC : 0.8395889**

~~~
	                                 Estimate Std. Error z value Pr(>|z|)    
(Intercept)                        1.466e+01  9.972e+02   0.015  0.98827    
biddable                           1.432e+00  1.733e-01   8.266  < 2e-16 ***
startprice                        -1.280e-02  1.234e-03 -10.372  < 2e-16 ***
conditionManufacturer refurbished  1.100e+00  5.581e-01   1.972  0.04865 *  
conditionNew                       1.065e+00  3.931e-01   2.709  0.00674 ** 
conditionNew other (see details)   9.819e-01  5.035e-01   1.950  0.05114 .  
conditionSeller refurbished        3.779e-02  4.179e-01   0.090  0.92795    
conditionUsed                      8.473e-01  2.779e-01   3.049  0.00229 ** 
cellular1                         -1.380e+01  9.972e+02  -0.014  0.98896    
cellularUnknown                   -1.436e+01  9.972e+02  -0.014  0.98851    
carrierNone                       -1.369e+01  9.972e+02  -0.014  0.98904    
carrierOther                       1.374e+01  1.455e+03   0.009  0.99247    
carrierSprint                      1.354e+00  7.040e-01   1.923  0.05453 .  
carrierT-Mobile                   -1.172e+00  9.755e-01  -1.202  0.22945    
carrierUnknown                    -2.702e-02  4.351e-01  -0.062  0.95049    
carrierVerizon                     3.277e-01  3.655e-01   0.897  0.36983    
colorGold                         -5.241e-01  6.295e-01  -0.833  0.40512    
colorSpace Gray                    8.264e-03  3.165e-01   0.026  0.97917    
colorUnknown                       5.179e-03  2.093e-01   0.025  0.98026    
colorWhite                        -4.772e-02  2.274e-01  -0.210  0.83383    
storage16                         -1.349e+00  5.406e-01  -2.495  0.01259 *  
storage32                         -1.214e+00  5.548e-01  -2.187  0.02871 *  
storage64                         -6.968e-01  5.400e-01  -1.290  0.19694    
storageUnknown                    -7.634e-01  7.014e-01  -1.088  0.27644    
productlineiPad 2                  6.435e-01  2.942e-01   2.187  0.02873 *  
productlineiPad 3                  1.062e+00  3.548e-01   2.993  0.00276 ** 
productlineiPad 4                  1.658e+00  3.939e-01   4.208 2.57e-05 ***
productlineiPad 5                  3.595e+00  2.058e+03   0.002  0.99861    
productlineiPad Air                2.349e+00  4.350e-01   5.399 6.70e-08 ***
productlineiPad Air 2              3.675e+00  5.586e-01   6.579 4.74e-11 ***
productlineiPad mini               8.824e-01  3.191e-01   2.765  0.00569 ** 
productlineiPad mini 2             2.234e+00  4.439e-01   5.031 4.87e-07 ***
productlineiPad mini 3             2.613e+00  6.024e-01   4.337 1.45e-05 ***
productlineiPad mini Retina       -1.226e+01  7.991e+02  -0.015  0.98776    
productlineUnknown                 3.406e-01  3.952e-01   0.862  0.38885    
	- 
~~~


### logistic\_regression_simple

Logistic Regression model using biddable, startprice, productline. Threshold 0.5

- Baseline accuracy : 0.5517751
- Accuracy : 0.7751479
- **AUC : 0.8386908**

~~~
Coefficients:
                              Estimate Std. Error z value Pr(>|z|)    
(Intercept)                  2.063e-01  2.364e-01   0.873 0.382773    
biddable                     1.565e+00  1.629e-01   9.607  < 2e-16 ***
startprice                  -1.007e-02  9.726e-04 -10.358  < 2e-16 ***
productlineiPad 2            4.546e-01  2.692e-01   1.688 0.091335 .  
productlineiPad 3            8.250e-01  3.322e-01   2.483 0.013027 *  
productlineiPad 4            1.206e+00  3.615e-01   3.335 0.000853 ***
productlineiPad 5            1.582e+01  8.827e+02   0.018 0.985704    
productlineiPad Air          1.859e+00  3.814e-01   4.874 1.09e-06 ***
productlineiPad Air 2        3.047e+00  4.757e-01   6.406 1.49e-10 ***
productlineiPad mini         6.327e-01  2.851e-01   2.220 0.026446 *  
productlineiPad mini 2       1.855e+00  4.119e-01   4.503 6.69e-06 ***
productlineiPad mini 3       1.986e+00  5.086e-01   3.905 9.43e-05 ***
productlineiPad mini Retina -1.188e+01  4.999e+02  -0.024 0.981045    
productlineUnknown          -2.564e-02  2.996e-01  -0.086 0.931819    
~~~

### cart_basic
Entry-level CART-based classifier using the significant varibles found from Logistic Regression to predict.

- Variables used in CART : biddable + startprice + condition + cellular + carrier + color + storage + productline
- Baseline accuracy : 0.5517751
- Accuracy : 0.7899408
- **AUC : 0.814947**
- Splits in the tree (top-to-bottom)
	- biddable, startprice >= 140 , productline, startprice >= 388

### forest_basic
Entry-level Random Forest classifier using significant variables from Logistic Regression to predict.

- Variables : biddable + startprice + condition + cellular + carrier + color + storage + productline
- Baseline accuracy : 0.5517751
- Accuracy : 0.7899408
- **AUC : 0.814947**




