# Examine variable selection results from glmmPen package 
# using "var_restrictions = 'fixef'" initialization option

library(stringr)

# Specify path to simulation results
path = "~/Longleaf/RJournal_GitHub/select_50Cov_var_restrict_B1"
# Specify path to save summary RData output object
path_save = "~/GitHub/cloud/RJournal_GitHub"

# Names of sub-folder directories
sims = str_c("sim",1:4)
# Labels of sub-folder directories
## beta = true slope, K = number of groups within data, SD = standard deviation of random effects
sim_labels = str_c("Beta_1",
                   "_K_",rep(c(5,10),each=2),
                   "_SD_",rep(c(1,round(sqrt(2),2)),times=2))

# Read in simulation results and create an RData object with relevant output
res = list()
for(s in 1:length(sims)){
  files = list.files(path = sprintf("%s/sim%i",path,s), full.names = TRUE)
  
  beta_mat = matrix(0, nrow = length(files), ncol = 51)
  vars_mat = matrix(0, nrow = length(files), ncol = 51)
  prescreen_mat = matrix(0, nrow = length(files), ncol = 51)
  time_vec = numeric(length(files))
  
  for(f in 1:length(files)){
    # Load 'output' list object
    load(files[f])
    # Extract relevant output from simulation results
    fit_glmmPen = output$fit_glmmPen
    ## fixed effect coefficient estimates
    beta = fit_glmmPen$fixef
    beta_mat[f,] = beta
    ## random effect variance estimates (from covariance matrix estimate)
    vars_vals = diag(fit_glmmPen$sigma)
    vars_mat[f,] = vars_vals
    ## time to complete variable selection procedure - convert from seconds to hours
    time_vec[f] = output$time_select[3] / 3600
    ## pre-screening results
    prescreen_mat[f,] = fit_glmmPen$penalty_info$prescreen_ranef
  }
  
  res[[sim_labels[s]]] = list(beta_mat = beta_mat, vars_mat = vars_mat, 
                              time_vec = time_vec, prescreen_mat = prescreen_mat)
}

save(res, file = sprintf("%s/select_50Cov_var_restrict.RData",path_save))

#############################################################################################################