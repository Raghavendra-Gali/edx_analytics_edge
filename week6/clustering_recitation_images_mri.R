##############################################################################
# WEEK 6 - Clustering - Recitation : MRI
#

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 4 : MRI IMAGE

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# Read in the healthy MRI dataset, convert to matrix, and check size
healthy = read.csv("healthy.csv", header = FALSE)
healthyMatrix = as.matrix(healthy)
str(healthyMatrix)
summary(healthy)

# Display the healthy matrix image
image(healthyMatrix, axes=FALSE, col = grey(seq(0,1,length=256)))

# Convert to a 1-d vector for clustering. 
healthyVector = as.vector(healthyMatrix)

# Now you need to calculate the pairwise distances
# distance = dist(healthyVector, method="euclidean") <- don't run this, it needs 2GB RAM!
str(healthyVector)

# The vector has n = 365636. Running time is: 66844659430 ! This is too big :-(
n = 365636
(n * (n-1))/2

# Can't use hierarchical clustering, change to K-Means clustering instead !!

# VIDEO 5: K-MEANS CLUSTERING

# Need to specify a number of clusters first, 'k'. Say 5.
k = 5

# 1st step of K-Means assigns points randomy to clusters, so need seed value
set.seed(1)

# Arguments are the vector to be clustered, how many clusters, and how many iterations
KMC = kmeans(healthyVector, centers=k, iter.max = 1000)

# Check the resulting KMC object:
# - cluster: cluster of each element in the input vector
# - centers: has the center of each of the centers of the K clusters
# - size: How many elements were assigned to each cluster
str(KMC)

healthyClusters = KMC$cluster
KMC$centers[2]

# Now create a new image with the segmentation output:
# Convert the 1-d vector into a 2-d matrix
dim(healthyClusters) = c(nrow(healthyMatrix), ncol(healthyMatrix) )
# Visualise the clusters, using the rainbow colour palette
image(healthyClusters, axes=FALSE, col = rainbow(k))

# VIDEO 6 : DETECTING TUMOURS

# Need this library to check the tumor example
library("flexclust")

tumor = read.csv("tumor.csv", header=FALSE)
tumorMatrix = as.matrix(tumor)
tumorVector = as.vector(tumorMatrix)

# Apply the k-means clustering result from the healthy image on the tumor image
# The healthy one is like a training data set, and the tumor is a test set

# Need to convert to the kcca data object type for K means clustering
KMC.kcca = as.kcca(KMC, healthyVector)

tumorClusters = predict(KMC.kcca, newdata = tumorVector)

# tumorClusters is a vector that assigns 1 - 5 to each of the pixels in the image
dim(tumorClusters) = c( nrow(tumorMatrix), ncol(tumorMatrix))

# Now visualise the tumor Clusters
image(tumorClusters, axes=FALSE, col=rainbow(k))
