## Results

### Pre-processing 

#### Replacing storagex with integer value



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
- Accuracy : 0.7849462
- **AUC : 0.853314**

~~~
Coefficients:
                              Estimate Std. Error z value Pr(>|z|)    
(Intercept)                  1.120e-01  2.187e-01   0.512  0.60840    
biddable                     1.700e+00  1.542e-01  11.030  < 2e-16 ***
startprice                  -8.932e-03  8.819e-04 -10.128  < 2e-16 ***
productlineiPad 2            2.730e-01  2.575e-01   1.060  0.28907    
productlineiPad 3            7.370e-01  3.156e-01   2.335  0.01954 *  
productlineiPad 4            7.620e-01  3.387e-01   2.250  0.02446 *  
productlineiPad 5            1.343e+01  3.247e+02   0.041  0.96700    
productlineiPad Air          1.485e+00  3.598e-01   4.126 3.68e-05 ***
productlineiPad Air 2        2.982e+00  4.536e-01   6.575 4.87e-11 ***
productlineiPad mini         4.932e-01  2.671e-01   1.846  0.06482 .  
productlineiPad mini 2       1.187e+00  3.793e-01   3.129  0.00175 ** 
productlineiPad mini 3       1.342e+00  4.793e-01   2.799  0.00512 ** 
productlineiPad mini Retina  2.132e+00  9.766e-01   2.183  0.02904 *  
productlineUnknown          -1.945e-01  2.943e-01  -0.661  0.50873    
~~~

### logistic\_regression\_simple\_bid\_nobid

Logistic Regression trained on the biddable and non-biddable auctions separately. Independent variables are: startprice + condition + storage + productline (biddable)
and startprice + productline (non-biddable)
Threshold 0.5

- Baseline accuracy :
- Accuracy : 0.8064516
- **AUC : 0.836363 **

- ebayBiddable: 837 records
    - Train : 586
    - Test 251
- ebayNonBiddable: 1024
    - Train 717
    - Test 307

##### Biddable Model Summary

~~~
Coefficients:
                                    Estimate Std. Error z value Pr(>|z|)    
(Intercept)                         5.956246   1.126249   5.289 1.23e-07 ***
startprice                         -0.024316   0.002521  -9.646  < 2e-16 ***
conditionManufacturer refurbished   0.488978   1.216443   0.402 0.687703    
conditionNew                        2.640073   0.751834   3.512 0.000446 ***
conditionNew other (see details)    2.940911   1.002234   2.934 0.003342 ** 
conditionSeller refurbished         0.419613   0.744051   0.564 0.572783    
conditionUsed                       1.335887   0.426084   3.135 0.001717 ** 
storage16                          -4.506972   1.038639  -4.339 1.43e-05 ***
storage32                          -3.794860   1.033761  -3.671 0.000242 ***
storage64                          -3.804231   1.040000  -3.658 0.000254 ***
storageUnknown                     -4.915051   1.154566  -4.257 2.07e-05 ***
productlineiPad 2                   0.840718   0.457171   1.839 0.065922 .  
productlineiPad 3                   2.370992   0.647437   3.662 0.000250 ***
productlineiPad 4                   1.747225   0.667120   2.619 0.008817 ** 
productlineiPad 5                  16.758454 882.743968   0.019 0.984853    
productlineiPad Air                 3.604342   0.705994   5.105 3.30e-07 ***
productlineiPad Air 2               6.869476   1.062240   6.467 1.00e-10 ***
productlineiPad mini                1.246527   0.487358   2.558 0.010536 *  
productlineiPad mini 2              3.376335   0.836861   4.035 5.47e-05 ***
productlineiPad mini 3              3.402480   1.001636   3.397 0.000681 ***
productlineiPad mini Retina        14.959292 882.743493   0.017 0.986479    
productlineUnknown                  0.373372   0.568240   0.657 0.511138    
---
~~~


##### Non-Biddable Model Summary

~~~
Coefficients:
                                   Estimate Std. Error z value Pr(>|z|)    
(Intercept)                       -0.552973   0.783775  -0.706 0.480484    
startprice                        -0.004689   0.001308  -3.584 0.000338 ***
conditionManufacturer refurbished  0.228705   0.647577   0.353 0.723961    
conditionNew                      -0.487494   0.457204  -1.066 0.286310    
conditionNew other (see details)   0.231309   0.525689   0.440 0.659928    
conditionSeller refurbished       -0.750833   0.508242  -1.477 0.139592    
conditionUsed                     -0.143567   0.349022  -0.411 0.680823    
storage16                          0.169569   0.691140   0.245 0.806187    
storage32                          0.144959   0.707231   0.205 0.837598    
storage64                          0.721356   0.679656   1.061 0.288529    
storageUnknown                     0.675688   0.769268   0.878 0.379753    
productlineiPad 2                 -0.062095   0.362755  -0.171 0.864086    
productlineiPad 3                  0.242738   0.448663   0.541 0.588489    
productlineiPad 4                  0.533620   0.452873   1.178 0.238677    
productlineiPad Air                0.239583   0.514973   0.465 0.641764    
productlineiPad Air 2              1.329588   0.606003   2.194 0.028233 *  
productlineiPad mini               0.511375   0.382602   1.337 0.181363    
productlineiPad mini 2             0.763031   0.527004   1.448 0.147654    
productlineiPad mini 3             0.408798   0.711449   0.575 0.565562    
productlineiPad mini Retina        1.320053   0.950785   1.388 0.165021    
productlineUnknown                -0.076059   0.462593  -0.164 0.869402    
---
~~~


### logistic\_regression\_simple\_bid\_nobid\_features

Logistic Regression trained on the biddable and non-biddable auctions separately. Independent variables are: 
- Biddable : startprice + condition + storage + productline
- Non-biddable : discount
Threshold 0.5

- Baseline accuracy : 0.5376344
- Accuracy : 0.8082437
- **AUC : 0.8402003 **

- ebayBiddable: 837 records
    - Train : 586
    - Test 251
- ebayNonBiddable: 1024
    - Train 717
    - Test 307

##### Biddable Model Summary

~~~
Coefficients:
                                    Estimate Std. Error z value Pr(>|z|)    
(Intercept)                         5.956246   1.126249   5.289 1.23e-07 ***
startprice                         -0.024316   0.002521  -9.646  < 2e-16 ***
conditionManufacturer refurbished   0.488978   1.216443   0.402 0.687703    
conditionNew                        2.640073   0.751834   3.512 0.000446 ***
conditionNew other (see details)    2.940911   1.002234   2.934 0.003342 ** 
conditionSeller refurbished         0.419613   0.744051   0.564 0.572783    
conditionUsed                       1.335887   0.426084   3.135 0.001717 ** 
storage16                          -4.506972   1.038639  -4.339 1.43e-05 ***
storage32                          -3.794860   1.033761  -3.671 0.000242 ***
storage64                          -3.804231   1.040000  -3.658 0.000254 ***
storageUnknown                     -4.915051   1.154566  -4.257 2.07e-05 ***
productlineiPad 2                   0.840718   0.457171   1.839 0.065922 .  
productlineiPad 3                   2.370992   0.647437   3.662 0.000250 ***
productlineiPad 4                   1.747225   0.667120   2.619 0.008817 ** 
productlineiPad 5                  16.758454 882.743968   0.019 0.984853    
productlineiPad Air                 3.604342   0.705994   5.105 3.30e-07 ***
productlineiPad Air 2               6.869476   1.062240   6.467 1.00e-10 ***
productlineiPad mini                1.246527   0.487358   2.558 0.010536 *  
productlineiPad mini 2              3.376335   0.836861   4.035 5.47e-05 ***
productlineiPad mini 3              3.402480   1.001636   3.397 0.000681 ***
productlineiPad mini Retina        14.959292 882.743493   0.017 0.986479    
productlineUnknown                  0.373372   0.568240   0.657 0.511138    
---
~~~


##### Non-Biddable Model Summary

~~~
Coefficients:
                                   Estimate Std. Error z value Pr(>|z|)    
(Intercept)                       -0.552973   0.783775  -0.706 0.480484    
startprice                        -0.004689   0.001308  -3.584 0.000338 ***
conditionManufacturer refurbished  0.228705   0.647577   0.353 0.723961    
conditionNew                      -0.487494   0.457204  -1.066 0.286310    
conditionNew other (see details)   0.231309   0.525689   0.440 0.659928    
conditionSeller refurbished       -0.750833   0.508242  -1.477 0.139592    
conditionUsed                     -0.143567   0.349022  -0.411 0.680823    
storage16                          0.169569   0.691140   0.245 0.806187    
storage32                          0.144959   0.707231   0.205 0.837598    
storage64                          0.721356   0.679656   1.061 0.288529    
storageUnknown                     0.675688   0.769268   0.878 0.379753    
productlineiPad 2                 -0.062095   0.362755  -0.171 0.864086    
productlineiPad 3                  0.242738   0.448663   0.541 0.588489    
productlineiPad 4                  0.533620   0.452873   1.178 0.238677    
productlineiPad Air                0.239583   0.514973   0.465 0.641764    
productlineiPad Air 2              1.329588   0.606003   2.194 0.028233 *  
productlineiPad mini               0.511375   0.382602   1.337 0.181363    
productlineiPad mini 2             0.763031   0.527004   1.448 0.147654    
productlineiPad mini 3             0.408798   0.711449   0.575 0.565562    
productlineiPad mini Retina        1.320053   0.950785   1.388 0.165021    
productlineUnknown                -0.076059   0.462593  -0.164 0.869402    
---
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

- Variables : biddable + discount + productline
- Baseline accuracy : 0.5376344
- Accuracy : 0.7616487
- **AUC : 0.847668**

### forest_basic_text
Entry-level Random Forest classifier using significant variables and text features

- Variables : biddable + discount + productline + 95% text features
- Baseline accuracy : 0.5376344
- Accuracy : 0.8010753
- **AUC : 0.8699677 (highest seen) **



### logistic\_regression\_simple_text

Logistic Regression model using biddable, startprice, productline and description text.The text of the review is also processed and added to the training data. Threshold 0.5 (doesn't affect AUC)

- Baseline accuracy : 0.5517751
- Accuracy : 0.7616487
- **AUC : 0.847668**
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





