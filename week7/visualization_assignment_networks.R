# VISUALIZATION - Assignment : Networks

# Need the ggplot2 library for fancy plots
library(ggplot2)

# Need the igraph library
library(igraph)

# Change into the directory and load data
rm(list=ls())
setwd("/Users/tim/Dropbox/courses/Analytics Edge/edx_analytics_edge/week7")

edges = read.csv("edges.csv")
users = read.csv("users.csv")

str(edges)
str(users)

edgeTable = table(edges$V1, edges$V2)
edgeTableMatrix = as.matrix(edgeTable)
nrow(edgeTableMatrix)
ncol(edgeTableMatrix)
sum(edgeTableMatrix)

# 1.2
table(users$locale, users$school)

# 1.3 
table(users$school, users$gender)

# 2.1
g = graph.data.frame(edges, FALSE, users)

# 2.2
plot(g, vertex.size=5, vertex.label=NA)

# 2.3 
degree(g) >= 10

# 2.4
V(g)$size = degree(g)/2+2
plot(g, vertex.label=NA)
max(V(g)$size)
min(V(g)$size)

# 3.1
V(g)$color = "black"
V(g)$color[V(g)$gender == "A"] = "red"
V(g)$color[V(g)$gender == "B"] = "gray"
plot(g, vertex.label=NA)

# 3.2
V(g)$color = "black"
V(g)$color[V(g)$school == "AB"] = "red"
V(g)$color[V(g)$school == "B"] = "gray"
V(g)$color[V(g)$school == "A"] = "blue"
plot(g, vertex.label=NA)

# 3.3
V(g)$color = "black"
V(g)$color[V(g)$locale == "A"] = "red"
V(g)$color[V(g)$locale == "B"] = "gray"
V(g)$color[V(g)$school == "AB"] = "blue"
plot(g, vertex.label=NA)


