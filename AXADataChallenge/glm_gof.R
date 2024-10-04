library(stats)
library(bootGOF)
library(ResourceSelection)
library(dplyr)
library(FOCI)
library(rstudioapi)

# Number of GOF test
n_gof <- 50

# Getting the path of your current open file
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

data <- read.csv("data_claimnb.csv")

p_val_coll <- c()
for (i in 1:n_gof) {
  
  print(paste("Run: ", i))
  
  data_small <- sample_n(data, 10000, replace = FALSE)
  
  poisson.model <- glm(ClaimNb ~ BonusMalus + DrivAge + offset(log(Exposure)), data_small, family = poisson(link = "log"))
  # summary(poisson.model)
  
  
  mt <- bootGOF::GOF_model(
    model = poisson.model,
    data = data_small,
    nmb_boot_samples = 100,
    simulator_type = "parametric",
    y_name = "ClaimNb",
    Rn1_statistic = Rn1_CvM$new())
  
  print(mt$get_pvalue())
  p_val_coll <- c(p_val_coll, mt$get_pvalue())
}

plot(ecdf(p_val_coll))
