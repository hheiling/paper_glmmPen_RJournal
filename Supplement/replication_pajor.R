# Compare Pajor Log-likelihood estimate from glmmPen package with the lme4 log-likelihood estimate

# Path to location of summary output object created in "extract_results_pajor.R"
## Object: "Pajor_loglike_vs_lme4.RData"
# path = "~/GitHub/cloud/RJournal_GitHub"

# Read in summary output object: "Pajor_loglik_vs_lme4.RData"
## loads 'res' list object
load(file = sprintf("%s/Pajor_loglik_vs_lme4.RData",path))

# Compare lme4 log-likelihood estimate (x-axis) with Pajor log-likelihood estimate from glmmPen package (y-axis)
for(i in 1:length(res)){
  sim_label = names(res)[i]
  ll_mat = res[[i]]
  plot(x = ll_mat[,1], y = ll_mat[,2],
       main = sim_label, xlab = "lme4 log-lik", ylab = "Pajor log-lik")
  abline(a = 0, b = 1)
}