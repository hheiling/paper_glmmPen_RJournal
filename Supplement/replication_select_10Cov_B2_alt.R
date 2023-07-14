# Examine variable selection results from glmmPen package 
# using "var_restrictions = 'fixef'" initialization option

# Path to location of summary output object created in "extract_results_select_10Cov_B2_alt.R"
## Object: "select_10Cov_B2_alt.RData"
path = "~/GitHub/cloud/RJournal_GitHub"

# Read in summary output object: select_10Cov_B2_alt.RData"
## loads 'res' list object
load(file = sprintf("%s/select_10Cov_B2_alt.RData",path))

# Compare variable selection results across the model selection criteria options 
# within each simulation condition
out_mat = matrix(0, nrow = length(res), ncol = 7)
colnames(out_mat) = c("Beta1","Beta2","TP % Fixed","FP % Fixed","TP % Random","TP % Random","Median Time (hrs)")
rownames(out_mat) = names(res)

for(i in 1:length(res)){
  sim_label = names(res)[i]
  
  # Extract relevant results
  beta_mat = res[[i]]$beta_mat
  vars_mat = res[[i]]$vars_mat
  time_vec = res[[i]]$time_vec
  
  # Calculate summary statistics, including average coefficient estimates, true/false positive percentages,
  #   and median time in hours to complete selection across simulation replicates
  b1 = round(mean(beta_mat[which(beta_mat[,2] != 0),2]),2)
  b2 = round(mean(beta_mat[which(beta_mat[,3] != 0),3]),2)
  tp_f = round(sum(beta_mat[,c(2,3)] != 0) / (2*length(files)) * 100, 1)
  fp_f = round(sum(beta_mat[,-c(1:3)] != 0) / ((ncol(beta_mat)-3)*length(files)) * 100, 1)
  tp_r = round(sum(vars_mat[,c(2,3)] != 0) / (2*length(files)) * 100, 1)
  fp_r = round(sum(vars_mat[,-c(1:3)] != 0) / ((ncol(vars_mat)-3)*length(files)) * 100, 1)
  
  out_mat[i,] = c(b1, b2, tp_f, fp_f, tp_r, fp_r, round(median(time_vec),2))
  
}

out_mat

##############################################################################################################