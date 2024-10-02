library(stats)
library(bootGOF)
library(ResourceSelection)
library(dplyr)
library(FOCI)
library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

data <- read.csv("data_avgclaimsev.csv")

data_small <- sample_n(data, 10000, replace = FALSE)
#data_small <- data_small[data_small$ClaimNb<5, ]

print(head(data_small))

gamma.model <- glm(AvgClaimAmount ~ BonusMalus + DrivAge, data_small, family = Gamma(link = "log"))
summary(gamma.model)


mt <- bootGOF::GOF_model(
  model = gamma.model,
  data = data_small,
  nmb_boot_samples = 100,
  simulator_type = "parametric",
  y_name = "AvgClaimAmount",
  Rn1_statistic = Rn1_CvM$new())

print(mt$get_pvalue())

