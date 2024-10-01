library(stats)
library(dplyr)
library(FOCI)
library(rstudioapi)

##################################################
# Little helper script for FOCI feature selection
##################################################

# Number of FOCI runs
n_foci <- 100

# Subsample size
n_subsamp <- 10000

# Getting the directory path of script file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

# Import data.frame (Python output)
# data <- read.csv("data_claimnb.csv")
data <- read.csv("data_avgclaimsev.csv")

# features <- data[ , !(names(data_small) %in% c("ClaimNb"))]

# Run FOCI on subsamples for n_foci iterations
foci_res <- c()
for (i in 1:n_foci) {
  print(paste("Run: ", i))
  data_subsample <- sample_n(data, n_subsamp, replace = FALSE)
  foci_res <- c(foci_res, foci(data_subsample$ClaimNb, select(data_subsample, BonusMalus, VehPower, DrivAge, VehAge, Density), numCores = 1, num_features=2))
}

# Get list of top features

# Desired rank
rank = 1

top_feature_list <- c()
for (i in 1:n_foci) {
  top_feature <- foci_res[i]$selectedVar[rank]$names
  if (!is.null(top_feature)) {
    top_feature_list <- c(top_feature_list, top_feature)
  }
}

# Count occurrences of each string 
string_counts <- table(top_feature_list) 

# Create a bar plot to help identify top features
barplot(string_counts,  
        main = paste("Top features for AvgClaimAmouny, FOCI runs:", n_foci),  
        ylab = "Top feature frequency",  
        col = "lightblue",  
        las = 2)  # las=2 makes the axis labels perpendicular to the axis 
