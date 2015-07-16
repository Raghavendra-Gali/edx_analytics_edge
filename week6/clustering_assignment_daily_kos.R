##############################################################################
# WEEK 6 - Clustering - Assignment  Daily Kos
#

# Uncomment to clear workspace on every run
rm(list=ls())


# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# Read in the healthy MRI dataset, convert to matrix, and check size
kos = read.csv("dailykos.csv", stringsAsFactors = FALSE)
str(kos)

# Calculate distances between all the articles based on their word content
distances = dist(kos, method="euclidean")

# cluster the articles using the previous distances and ward.D algorithm
clusterKos = hclust(distances, method = "ward.D")
plot(clusterKos)

# 1.4 - Use 7 clusters
clusterGroups = cutree(clusterKos, k = 7)
str(clusterGroups)

cluster1 = subset(kos, clusterGroups == 1)
cluster2 = subset(kos, clusterGroups == 2)
cluster3 = subset(kos, clusterGroups == 3)
cluster4 = subset(kos, clusterGroups == 4)
cluster5 = subset(kos, clusterGroups == 5)
cluster6 = subset(kos, clusterGroups == 6)
cluster7 = subset(kos, clusterGroups == 7)

# 1.5 - Hierarchical clustering

# This command prints out the top 6 terms in cluster1
tail(sort(colMeans(cluster1)))

# Same for cluster 2
tail(sort(colMeans(cluster2)))

# Search for IRAQ war in the other clusters
tail(sort(colMeans(cluster3)))
tail(sort(colMeans(cluster4)))
tail(sort(colMeans(cluster5)))
tail(sort(colMeans(cluster6)))
tail(sort(colMeans(cluster7)))

# 2.1 - Run k-means clustering with seed of 1000, k = 7
set.seed(1000)

# Arguments are the vector to be clustered, how many clusters, and how many iterations
k = 7
KMC = kmeans(kos, centers=k)
str(KMC)
table(KMC$cluster)

KMC$size

# Pull out subsets of the dataset using the cluster assignments
KMCCluster1 = subset(kos, KMC$cluster == 1)
KMCCluster2 = subset(kos, KMC$cluster == 2)
KMCCluster3 = subset(kos, KMC$cluster == 3)
KMCCluster4 = subset(kos, KMC$cluster == 4)
KMCCluster5 = subset(kos, KMC$cluster == 5)
KMCCluster6 = subset(kos, KMC$cluster == 6)
KMCCluster7 = subset(kos, KMC$cluster == 7)

# Now summarise the most frequent terms in each cluster


tail(sort(colMeans(KMCCluster1)))
tail(sort(colMeans(KMCCluster2)))
tail(sort(colMeans(KMCCluster3)))
tail(sort(colMeans(KMCCluster4)))
tail(sort(colMeans(KMCCluster5)))
tail(sort(colMeans(KMCCluster6)))
tail(sort(colMeans(KMCCluster7)))

# 2.3 - Compare hierarchical clusters to K-Means Cluster 2

table(clusterGroups, KMC$cluster)





