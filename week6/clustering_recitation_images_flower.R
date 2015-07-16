##############################################################################
# WEEK 6 - Clustering - Recitation : Image clustering
#

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 2 : CLUSTERING PIXELS

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# Read in the matrix of pixels, there are no headers for this image data.
# R treats the data as 50 observations of 50 variables ! Conver to matrix.
flower = read.csv("flower.csv", header = FALSE)
str(flower)

# Convert the dataframe into a matrix representation (50 rows, 50 columns)
flowerMatrix = as.matrix(flower)
str(flowerMatrix)

# Start by doing clustering, and not look at image first. First need to 
# convert the matrix into 1-d vector, and then cluster them. The size
# of teh vector is 50 * 50 = 2500 values
flowerVector = as.vector(flowerMatrix)
str(flowerVector)

# Why couldn't you use as.vector() with the original dataframe?
# => This doesn't work, the 1d vector is the same as the dataframe
flowerVector2 = as.vector(flower)
str(flowerVector2)

distance = dist(flowerVector, method = "euclidean")

# VIDEO 3: HIERARCHICAL CLUSTERING

# The ward method tries to find compact and spherical clusters
clusterIntensity = hclust(distance, method = "ward.D2")
plot(clusterIntensity)

# Dendogram interpretation (in notes). Try using 3 clusters, plot on the dendrogram
rect.hclust(clusterIntensity, k=3, border="red")

# Cut the tree into 3 clusters
flowerClusters = cutree(clusterIntensity, k=3)

# Check the flowerClusters variable. It shows which of the three clusters the pixel
# was assigned to.
flowerClusters

# Check how the grouping of pixel intensity looks in each of the 3 clusters
tapply(flowerVector, flowerClusters, mean)

# Convert the flowerClusters into a 50x50 matrix, and visualise them as an image
dim(flowerClusters) = c(50, 50)
flowerClusters[25]
image(flowerClusters, axes=FALSE)
image(flowerClusters, axes=FALSE, col=grey(seq(0,1,length=256)))

# how does it compare to the flower input?
image(flowerMatrix, axes=FALSE, col=grey(seq(0,1,length=256)))





