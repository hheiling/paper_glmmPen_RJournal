# Perform variable selection on Binomial data
# Test accuracy of glmmPen for Binomial family


library(glmmPen) 
library(stringr)

# Arrays 1-400 - 4 simulation types, 100 replicates per simulation type
array_val <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))

# Path to home folder
header_nas = "~/"
# Path to additional scratch space
header_pine = "/work/users/h/h/hheiling/"
# Name of subfolders to save results
sub_folder = "select_50Cov_var_restrict_B1/"
# prefix: folder to save results
## prefix0: location to save main output files
prefix0 = str_c(header_nas, "RJournal_GitHub/",sub_folder)
if(!dir.exists(prefix0)){dir.create(prefix0, recursive = TRUE)}
## prefix0_post: location to save files of posterior draws needed for BIC-ICQ calculations
prefix0_post = str_c(header_pine, "RJournal_GitHub/",sub_folder)
if(!dir.exists(prefix0_post)){dir.create(prefix0_post, recursive = TRUE)}

# 100 simulation replicates needed
sim_total = 100

beta_val = c(1)
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
prefix_BICq = str_c(prefix0_post, "Post_sim", sim_num) 
if(!dir.exists(prefix_BICq)){dir.create(prefix_BICq, recursive = TRUE)}

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
seeds = sample(1000:9999, size = sim_total, replace = F)

dat = sim.data(n = N, ptot = 50, pnonzero = 2, nstudies = K,
               sd_raneff = sd_ranef, family = 'binomial',
               seed = seeds[batch], imbalance = 1, 
               pnonzerovar = 0, beta = c(0, rep(beta,2)))


y = dat$y
X = dat$X[,-1]
group = dat$group


# Default optimControl arguments
start1 = proc.time()
set.seed(seeds[batch])
fit_glmmPen = glmmPen(formula = y ~ X + (X | group), family = "binomial",
                      covar = "independent", optim_options = optimControl(var_restrictions = "fixef"),
                      tuning_options = selectControl(BIC_option = "BICq", pre_screen = TRUE,
                                                     search = "abbrev", lambda.min.presc = 0.05),
                      BICq_posterior = sprintf("%s/BICq_post_Batch_%s", prefix_BICq, batch_label))
end1 = proc.time()



output = list(fit_glmmPen = fit_glmmPen, time_select = (end1 - start1))

save(output, file = sprintf("%s/Output_%s.RData", prefix, batch_label))


file.remove(sprintf("%s/BICq_post_Batch_%s.bin", prefix_BICq, batch_label))
file.remove(sprintf("%s/BICq_post_Batch_%s.desc", prefix_BICq, batch_label))

################################################################################################

print(gc(full = TRUE))

q(save="no")

################################################################################################
