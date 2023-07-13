# Compare Pajor Log-likelihood estimate from glmmPen package with the lme4 log-likelihood estimate

library(stringr)

# Specify path to Pajor_loglik_vs_lme4 simulation results
path = "~/Longleaf/RJournal_GitHub/Pajor_loglik_vs_lme4"
# Specify path to save summary RData output object
path_save = "~/GitHub/cloud/RJournal_GitHub"

# Names of sub-folder directories
sims = str_c("sim",1:8)
# Labels of sub-folder directories
## beta = true slope, K = number of groups within data, SD = standard deviation of random effects
sim_labels = str_c("Beta_",rep(c(1,2),each=4),
                   "_K_",rep(rep(c(5,10),each=2),times=2),
                   "_SD_",rep(c(1,round(sqrt(2),2)),times=4))

# Read in simulation results and create an RData object with log-likelihood output
res = list()
for(s in 1:length(sims)){
  files = list.files(path = sprintf("%s/sim%i",path,s), full.names = TRUE)
  ll_mat = matrix(0,nrow = length(files), ncol = 2)
  for(f in 1:length(files)){
    # Load 'output' list object
    load(files[f])
    # Extract log-likelihood information
    ll_mat[f,] = output$ll_vals
  }
  colnames(ll_mat) = names(output$ll_vals)
  res[[sim_labels[s]]] = ll_mat
}

save(res, file = sprintf("%s/Pajor_loglik_vs_lme4.RData",path_save))

#############################################################################################################