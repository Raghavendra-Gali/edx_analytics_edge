## Notes
Ideas to improve results

- Can you impute the sold variable on the test set and use that to increase the amount of observations?
- Tune the threshold? Doesn't affect AUC, only accuracy
- Missing data?
- People describe the quality / standard of the ipad in the ebay description .. can you pull this out?
- Split between biddable and non-biddable sales?
- Add in features of the models (diagonal, weight, etc?) as well as the productline?
- Impute missing values
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
    -   Productline : 516 / 1861 = 27.7%
    -   


