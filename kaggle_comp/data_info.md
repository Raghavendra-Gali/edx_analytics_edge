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
- Tune the threshold? Doesn't affect AUC, only accuracy
- Missing data?
- People describe the quality / standard of the ipad in the ebay description .. can you pull this out?
- Split between biddable and non-biddable sales?
- Add in features of the models (diagonal, weight, etc?) as well as the productline?
- 

## Models of ipad

**table(ebay$productline)**

[http://www.apple.com/shop/ipad/compare](Apple Store)

- iPad 1 (227)
- iPad 2 (286)
- iPad 3 (153)
- iPad 4 (157) - Refurbished
	- Cellular 32GB $449, 64GB $499, 128GB $589
- iPad 5 (1)
- iPad Air (180) - in Apple Store
	- WiFi 16GB $399, WiFi 32GB $449
	- Cellular 16GB $529, Cellular 32GB $579
- iPad Air 2 (171) - in Apple Store
	- WiFi 16GB $499, 64GB $599, 128GB $699
	- Cellular 16GB $629, 64GB $729, 128GB $829
- iPad mini (277) - (Refurbished)
	- Wifi 16GB $209
	- Cellular 16GB $309, 32GB $359, 64GB $409
- iPad mini 2 (107) - in Apple Store
	- Wifi: 16GB $299, 32GB $349
	- Cellular: 16GB $429, 32GB $479
- iPad mini 3 (90) - in Apple Store
	- Wifi: 16GB $399, 64GB $499, 128GB $599
	- Cellular: 16GB $529, 64GB $629, 128GB $729
- iPad mini Retina (8)
- Unknown (204)

**table(ebay$productline, ebay$storage)**

~~~
                   128  16  32  64 Unknown
  iPad 1             0  86  72  59      10
  iPad 2             0 169  68  44       5
  iPad 3             1  69  38  39       6
  iPad 4            11  81  41  16       8
  iPad 5             0   0   1   0       0
  iPad Air          24  82  45  25       4
  iPad Air 2        33  71   0  63       4
  iPad mini          1 199  34  29      14
  iPad mini 2        7  64  22  14       0
  iPad mini 3       12  56   0  20       2
  iPad mini Retina   0   5   2   0       1
  Unknown            1  52  17   5     129
~~~


## Data Exploration

- Total records = 1861
	- Biddable : 837 observations
	- Non-biddable : 1024 observations
- Unknowns / Missing data
    -   Cellular : 234 / 1861 = 12.5%
    -   Color : 708 / 1861 = 38%
    -   Storage : 183 / 1861 = 9.83%
    -   




## Results

### logistic_regression

Logistic Regression model using biddable, startprice, condition, cellular, carrier, color, storage, productline. Threshold 0.5.

- Baseline Accuracy : 0.5376344
- Accuracy : 0.7795699
- **AUC : 0.838792**

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

- Baseline accuracy : 0.5376344
- Accuracy : 0.7867384
- **AUC : 0.8447739**

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

### logistic\_regression\_simple\_bid\_nobid

Logistic Regression trained on the biddable and non-biddable auctions separately. Threshold 0.5

- Baseline accuracy :
- Accuracy :
- **AUC : **

- ebayBiddable: 837 records
    - Train : 586
    - Test 251
- ebayNonBiddable: 1024
    - Train 717
    - Test 307



##### Biddable Model Summary

~~~
                               Estimate Std. Error z value Pr(>|z|)    
(Intercept)                        2.151e+01  2.400e+03   0.009 0.992849    
biddable                                  NA         NA      NA       NA    
startprice                        -2.448e-02  2.557e-03  -9.577  < 2e-16 ***
conditionManufacturer refurbished  2.115e-01  1.203e+00   0.176 0.860381    
conditionNew                       2.679e+00  7.952e-01   3.369 0.000754 ***
conditionNew other (see details)   2.900e+00  1.061e+00   2.733 0.006285 ** 
conditionSeller refurbished        4.287e-01  7.638e-01   0.561 0.574607    
conditionUsed                      1.290e+00  4.310e-01   2.993 0.002767 ** 
cellular1                         -1.516e+01  2.400e+03  -0.006 0.994960    
cellularUnknown                   -1.592e+01  2.400e+03  -0.007 0.994706    
carrierNone                       -1.486e+01  2.400e+03  -0.006 0.995060    
carrierOther                       1.540e+01  1.624e+03   0.009 0.992434    
carrierSprint                      1.304e+01  7.259e+02   0.018 0.985665    
carrierT-Mobile                    4.310e-01  1.438e+00   0.300 0.764410    
carrierUnknown                     7.931e-01  7.784e-01   1.019 0.308236    
carrierVerizon                     7.376e-01  6.863e-01   1.075 0.282457    
colorGold                         -2.243e+00  1.307e+00  -1.716 0.086095 .  
colorSpace Gray                   -2.811e-01  5.459e-01  -0.515 0.606669    
colorUnknown                      -5.508e-01  3.741e-01  -1.472 0.140917    
colorWhite                        -2.342e-01  4.187e-01  -0.559 0.575943    
storage16                         -4.818e+00  1.145e+00  -4.208 2.58e-05 ***
storage32                         -4.065e+00  1.132e+00  -3.590 0.000331 ***
storage64                         -4.179e+00  1.141e+00  -3.662 0.000250 ***
storageUnknown                    -4.972e+00  1.305e+00  -3.811 0.000138 ***
productlineiPad 2                  7.690e-01  4.847e-01   1.587 0.112622    
productlineiPad 3                  2.201e+00  6.704e-01   3.284 0.001025 ** 
productlineiPad 4                  1.666e+00  6.803e-01   2.448 0.014355 *  
productlineiPad 5                  3.606e+00  2.898e+03   0.001 0.999007    
productlineiPad Air                3.576e+00  7.507e-01   4.763 1.91e-06 ***
productlineiPad Air 2              7.202e+00  1.152e+00   6.252 4.05e-10 ***
productlineiPad mini               1.296e+00  5.215e-01   2.486 0.012930 *  
productlineiPad mini 2             3.367e+00  8.574e-01   3.927 8.61e-05 ***
productlineiPad mini 3             3.751e+00  1.100e+00   3.409 0.000651 ***
productlineiPad mini Retina        1.685e+01  2.400e+03   0.007 0.994399    
productlineUnknown                 4.649e-01  6.756e-01   0.688 0.491376    
~~~


##### Non-Biddable Model Summary

~~~
                                    Estimate Std. Error z value Pr(>|z|)    
(Intercept)                        13.936292 615.386753   0.023 0.981932    
biddable                                  NA         NA      NA       NA    
startprice                         -0.004412   0.001293  -3.412 0.000645 ***
conditionManufacturer refurbished   0.154385   0.670136   0.230 0.817798    
conditionNew                       -0.427181   0.464491  -0.920 0.357742    
conditionNew other (see details)    0.171737   0.534719   0.321 0.748080    
conditionSeller refurbished        -0.759065   0.516863  -1.469 0.141941    
conditionUsed                      -0.140057   0.353385  -0.396 0.691860    
cellular1                         -14.024827 615.386109  -0.023 0.981818    
cellularUnknown                   -13.708912 615.386044  -0.022 0.982227    
carrierNone                       -14.446092 615.386141  -0.023 0.981272    
carrierSprint                      -0.161369   0.743660  -0.217 0.828213    
carrierT-Mobile                    -0.279728   1.178767  -0.237 0.812420    
carrierUnknown                     -0.817127   0.544757  -1.500 0.133618    
carrierVerizon                     -0.383897   0.410195  -0.936 0.349330    
colorGold                          -1.001808   0.664843  -1.507 0.131853    
colorSpace Gray                    -0.628589   0.416793  -1.508 0.131515    
colorUnknown                       -0.225691   0.260290  -0.867 0.385901    
colorWhite                         -0.468152   0.296349  -1.580 0.114168    
storage16                           0.193780   0.699140   0.277 0.781651    
storage32                           0.149680   0.717394   0.209 0.834726    
storage64                           0.704368   0.689981   1.021 0.307325    
storageUnknown                      0.778400   0.873192   0.891 0.372692    
productlineiPad 2                  -0.007968   0.377463  -0.021 0.983158    
productlineiPad 3                   0.326169   0.455561   0.716 0.474010    
productlineiPad 4                   0.585515   0.458034   1.278 0.201136    
productlineiPad Air                 0.363158   0.531446   0.683 0.494393    
productlineiPad Air 2               1.668365   0.637167   2.618 0.008834 ** 
productlineiPad mini                0.601242   0.392845   1.530 0.125898    
productlineiPad mini 2              1.017033   0.546291   1.862 0.062645 .  
productlineiPad mini 3              0.796818   0.730305   1.091 0.275239    
productlineiPad mini Retina         1.653587   0.975979   1.694 0.090211 .  
productlineUnknown                  0.085760   0.493739   0.174 0.862105    

~~~

### cart_basic
Entry-level CART-based classifier using the significant varibles found from Logistic Regression to predict.

- Variables used in CART : biddable + startprice + condition + cellular + carrier + color + storage + productline
- Baseline accuracy : 0.5376344
- Accuracy : 0.797491
- **AUC : 0.8097481**
- Splits in the tree (top-to-bottom)
	- biddable, startprice >= 140 , productline, startprice >= 388

### forest_basic
Entry-level Random Forest classifier using significant variables from Logistic Regression to predict.

- Variables : biddable + startprice + condition + cellular + carrier + color + storage + productline
- Baseline accuracy : 0.5376344
- Accuracy : 0.8010753
- **AUC : 0.8093217**

### logistic\_regression\_simple_text

Logistic Regression model using biddable, startprice, productline and description text.The text of the review is also processed and added to the training data. Threshold 0.5 (doesn't affect AUC)

- Baseline accuracy : 0.5517751
- Accuracy : 0.7616487
- **AUC : 0.8171641**
- Text processing notes
	- For some reason, stopword stopword removal as below wouldn't work :-/
		- corpus = tm_map(corpus, removeWords, stopwords("english"))
	- Sparsity removal used with 99%


### cart\_basic\_text <- not finished, can't submit

Based on cart_basic, but using text features from logistic\_regression\_simple\_text. The features from the original dataset are sold, biddable, startprice, and productline.

- Baseline accuracy : 0.5517751
- Accuracy : 0.8046595 (identical to cart_basic !)
- **AUC : 0.8097481 \(identical to cart\_basic \!\) **


### cluster_hier

Hierarchical clustering, to try and find trends in the data.

### cluster\_hier\_logistic\_regression\_simple

Hierarchical clustering to create clusters of training data. Then train multiple separate logistic regression models in parallel with these 4 clusters.


# Summary

| Model     |





