##############################################################################
# WEEK 6 - Clustering - Video : Movie Lens movie
#

# Uncomment to clear workspace on every run
rm(list=ls())

# VIDEO 6 : GETTING THE DATA

# Set working directory and read in the csv file
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week6")

# The movie database uses '|' as a separator, not comma, so can't use read.csv
movies = read.table("movieLens.txt", header=FALSE, sep="|", quote="\"")
str(movies)
# summary(movies)

# movies structure has 1682 observations of 24 variables. We didn't specify
# header names in the source file, so R calls them V1, V2, ..,  V24


# Create column names using teh header titles
colnames(movies) = c("ID", "Title", "ReleaseDate", "VideoReleaseDate", "IMDB", "Unknown", 
                     "Action",  "Adventure",  "Animation", "Children's",  "Comedy",  
                     "Crime",  "Documentary",  "Drama",  "Fantasy", "Film-Noir",  
                     "Horror",  "Musical",  "Mystery",  "Romance",  "Sci-Fi", 
                     "Thriller",  "War",  "Western")
str(movies)

# Remove the unwanted variables (only need the genres to cluster together, and the title)
movies$ID = NULL
movies$ReleaseDate = NULL
movies$VideoReleaseDate = NULL
movies$IMDB = NULL

# There are also some duplicates in the dataset. Use the unique() command to remove them
movies = unique(movies)
str(movies)

# QUICK QUESTION
nrow(subset(movies, movies$Comedy == 1))
nrow(subset(movies, movies$Western == 1))
nrow(subset(movies, (movies$Romance == 1) & (movies$Drama == 1)))

# VIDEO 7: HIERARCHICAL CLUSTERING IN R

# Two steps to hierarchical clustering
# 1. Compute distances between all datapoints
# 2. Compute cluster allocations

# Only need to cluster movies based on the genre variable, so nee dcols 2 - 20
distances = dist(movies[2:20], method="euclidean")
clusterMovies = hclust(distances, method = "ward.D")

# Now plot the dendogram of the clustering algorithm. The black boxes at the 
# bottom are all the individual points in teh dataset which later get merged
plot(clusterMovies)

# Looks like 3 or 4 clusters would be good based on dendogram, but we need to
# recomend more than just 3 groups of movies. Use 10 clusters for now.
clusterGroups = cutree(clusterMovies, k = 10)

# Use tapply to compute the percentage of movies in each cluster.
# This command divides our dataset into 10 clusters, and then
# computes the percentage of movies with Action == 1 in each cluster
tapply(movies$Action, clusterGroups, mean)

# Check the percentage of Romance movies in each cluster
tapply(movies$Romance, clusterGroups, mean)

# By doing this for each of the clusters, and checking what genre the are, you 
# can come up with labels for each of the clusters.

# Amy liked the movie Men In Black, which cluster is that in?
# First of all, find which row Men in Black is in..
subset(movies, Title=="Men in Black (1997)")

# .. now find out which cluster that row was added to: 2.
# 2 is the action/adventure/scifi cluster
clusterGroups[257]

# Find out what other movies have been clustered along with Men in Black
cluster2 = subset(movies, clusterGroups == 2)
cluster2$Title[1:10]

# QUICK QUESTION - When clustering into 2 groups, cluster 2 is all the same genre
clusterGroups = cutree(clusterMovies, k = 2)
subset(movies, clusterGroups == 2)



