# Compare Pajor Log-likelihood estimate from glmmPen package with the lme4 log-likelihood estimate

library(glmmPen) 
library(stringr)
library(lme4)

# Arrays 1-800 - 8 simulation types, 100 replicates per simulation type
array_val <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))

# Path to home folder
header_nas = "~/"
# Path to additional scratch space
header_pine = "/pine/scr/h/h/hheiling/"
# Name of subfolders to save results
sub_folder = "Pajor_loglik_vs_lme4/"
# prefix: folder to save results
## prefix0: location to save main output files
prefix0 = str_c(header_nas, "RJournal_GitHub/",sub_folder)
if(!dir.exists(prefix0)){dir.create(prefix0, recursive = TRUE)}

# 100 simulation replicates needed
sim_total = 100

beta_val = c(1,2)
sd_val = c(1,sqrt(2))
K_val = c(5,10)
combos = expand.grid(sd_val, K_val, beta_val)
colnames(combos) = c("sd_val","K_val","beta_val")
combos

# Place each simulation set-up into separate sub-folder
if((array_val %% sim_total) != 0){
  batch = array_val %% sim_total
  sim_num = array_val %/% sim_total + 1
}else{
  batch = sim_total # 100
  sim_num = array_val %/% sim_total 
}

print(batch)
print(sim_num)
print(combos[sim_num,])

# prefix and prefix_BICq: folder to save results and posterior needed for BIC-ICQ, respectively
prefix = str_c(prefix0, "sim", sim_num) 
if(!dir.exists(prefix)){dir.create(prefix, recursive = TRUE)}

if(batch <= 9){
  batch_label = str_c("00",batch)
}else if(batch <= 99){
  batch_label = str_c("0",batch)
}else{
  batch_label = as.character(batch)
}

# Extract relevant values from combinations
sd_ranef = combos[sim_num,"sd_val"]
K = combos[sim_num,"K_val"]
beta = combos[sim_num,"beta_val"]

# Simulation of data

N = 500

set.seed(2021) 
seeds = sample(1000:9999, size = sim_total, replace = FALSE)

dat = sim.data(n = N, ptot = 2, pnonzero = 2, nstudies = K,
               sd_raneff = sd_ranef, family = 'binomial',
               seed = seeds[batch], imbalance = 1, 
               pnonzerovar = 0, beta = c(0, rep(beta,2)))


y = dat$y
X = dat$X[,-1]
group = dat$group


# Default optimControl arguments
start1 = proc.time()
set.seed(seeds[batch])
fit_glmm = glmm(formula = y ~ X + (X | group), family = "binomial",
                covar = "unstructured", optim_options = optimControl())
end1 = proc.time()

fit_lme4 = glmer(formula = y ~ X + (X | group), family = "binomial")

ll_vals = c(logLik(fit_lme4), logLik(fit_glmm))
names(ll_vals) = c("lme4","glmm")

output = list(fit_glmm = fit_glmm, fit_lme4 = fit_lme4,
              ll_vals = ll_vals)

save(output, file = sprintf("%s/Output_%s.RData", prefix, batch_label))

################################################################################################

print(gc(full = TRUE))

q(save="no")

################################################################################################
