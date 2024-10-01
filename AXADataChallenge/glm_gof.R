library(stats)
library(bootGOF)
library(ResourceSelection)
library(dplyr)
library(FOCI)
library(rstudioapi)

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

data <- read.csv("out.csv")

data_small <- sample_n(data, 10000, replace = FALSE)
data_small <- data_small[data_small$ClaimNb<5, ]

print(head(data_small))

poisson.model <- glm(ClaimNb ~ BonusMalus + VehPower + offset(log(Exposure)), data_small, family = poisson(link = "log"))
summary(poisson.model)


mt <- bootGOF::GOF_model(
  model = poisson.model,
  data = data_small,
  nmb_boot_samples = 200,
  simulator_type = "parametric",
  y_name = "ClaimNb",
  Rn1_statistic = Rn1_CvM$new())

print(mt$get_pvalue())

