# Introduction and Installation

This GitHub repository contains the example code, simulation materials, and supplemental results discussed within the paper "glmmPen: High Dimensional Penalized Generalized Linear Mixed Models" by Heiling et al., which describes the glmmPen R package. This paper has been submitted to the R Journal and has been uploaded to the ArXiv online journal.

The code to run the glmmPen method is provided in the glmmPen R package available on CRAN at https://cran.r-project.org/web/packages/glmmPen/index.html and is also available in the GitHub respository https://github.com/hheiling/glmmPen.

Install glmmPen R package from CRAN using the following R code:
```
install.packages("glmmPen")
library(glmmPen)
```

Install glmmPen R package from the GitHub repository https://github.com/hheiling/glmmPen using the following R code:
```
library(devtools)
install_github("hheiling/glmmPen")
```

# Replication

The folder Replication/ contains the code and materials needed to replicate the in-text examples and the tables and figures within the paper. Below is a description of the code and materials contained within this folder.

### "heiling-glmmPen.R" 

The "heiling-glmmPen.R" code runs the primary example given in the paper, which uploads the 'basal' dataset provided within the package, specifies a generalized linear mixed model with 10 covariates, and performs variable selection on the fixed and random effects of this model. This code also applies several S3 method functions to the fit object created from this example and uses this output to replicate the figures given within the paper. 

The simulations discussed in the paper would take a long time to run, so this code reads in RData objects with summary results from these simulations and uses these results to replicate the tables given within the paper. A sample example of simulating a single dataset and running the variable selection procedure on this simulated dataset is also provided.

In order to replicate the code output, tables, and figures within the paper, run the following R code:
```
# Set working directory to Replication/ folder contents, edit line below as needed
setwd("~/Replication/")
# Call 'heiling-glmmPen.R' code
source("hheiling-glmmPen.R")
```

### RData files 

The RData files provided in this folder contain output from the simulations discussed in the paper. As a result, users of this repo can replicate the tables summarizing the simulation results without having to run all of the simulations themselves, which take some time to run. 

Each individual RData file contains the results for a single simulation set-up (100 replicates per simulation set-up). The contents from each RData file are used to create the summary statistics for a single line in one of the tables given in the paper. 

### "heiling-glmmPen-extra.R" 

The "hheiling-glmmPen-extra.R" code runs a secondary code example given in the paper, which uploads the 'basal' dataset provided within the package, specifies a generalized linear mixed model with 10 covariates, and fits a single generalized linear model with no penalization applied to the fixed or random effects.

In order to run this secondary code example, run the following R code:
```
# Set working directory to Replication/ folder contents, edit line below as needed
setwd("~/Replication/")
# Call 'heiling-glmmPen-extra.R' code
source("hheiling-glmmPen-extra.R")
```

### Simulation code

The subfolders "sims_on_cluster" and "sims_serial" contain the code to re-run the simulations presented in the paper.

The folder "sims_on_cluster" contains the code needed to run the p=10 and p=50 simulation replicates in parallel on a computing cluster: "paper_select_10Cov_B1_alt.R" and "paper_select_50Cov_B1_alt.R", respectively. In order to run the code, the following line must be manually adjusted:

* Line 19: Change "prefix0" variable as desired, which specifies the directory location where all simulation output materials are to be stored.

Linux code to submit the jobs to a computing cluster:
```
sbatch --array=1-400 -N 1 -t 5:00:00 --mem=1g -n 1 --output=selectp10B1_%a.out --wrap="R CMD BATCH paper_select_10Cov_B1_alt.R selectp10B1_$SLURM_ARRAY_TASK_ID.Rout"

sbatch --array=1-400 -N 1 -t 72:00:00 --mem=1g -n 1 --output=selectp50B1_%a.out --wrap="R CMD BATCH paper_select_50Cov_B1_alt.R selectp50B1_$SLURM_ARRAY_TASK_ID.Rout"
```

Once all simulations have been run on the cluster, run the code "Replication/sims_on_cluster/sim_create_RData.R" to take the simulation output and re-create the RData objects used to create the tables reported in the paper. The user will need to manually specify Line 45: "prefix" variable definition, giving the directory location where the simulation results are stored.

The folder "sims_serial" contains the code needed to run the simulation replicates in serial. Warning: Running all p=50 simulations in serial will take a very long time. We highly recommend running all simulations in parallel on a computing cluster. Line 20 giving the definition of "prefix0", the variable describing the directory location where the simulation results should be stored, needs to be manually edited.

R code to run the simulations in serial:
```
# Specify path location of the "_sim_all_serial.R" code, chance code below as needed
path = "~/Replication/sims_serial"
# Call "_sim_all_serial.R" code
source(sprintf("%s/_sim_all_serial.R",path))
```

# Suppplement

In our paper, we make some claims and recommendations based on empirical results we have observed in simulations which are not directly reported within the paper due to space considerations. To support some of our paper discussions, we present additional code and materials within the Supplement/ folder.

For each simulation of interest, we provide 4 items:

1. Code to run the simulations
2. Code to extract relevant simulation output, labeled with prefix "extract_results_"
3. RData file that contains the relevant simulation output. Because these are provided, interested readers do not necessarily need to run the code listed in steps 1 and 2 in order to examine summary plots or statistics. Instead, they can skip to step 4.
4. Code to create summary plots or statistics, labeled with prefix "replication_"

The code to run the supplemental simulations includes the following files:

* "Pajor_loglik_vs_lme4.R" - We use these simulations to support our claim that the Pajor log-likelihood estimate calculated from the glmmPen R package matches closely with the log-likelihood estimate calculated by the lme4 R package in low-dimensional settings. This code simulates low-dimensional datasets and fits these data to generalized linear mixed models using both the glmmPen R package (models fit without penalization) and the lme4 R package. The log-likelihood values calculated from each method -- the Pajor marginal log-likelihood calculated from the glmmPen package and the log-likelihood estimate calculated from the lme4 package -- are saved.
* "model_select_comparison.R" - We use these simulations to illustrate the differences in model selection performance for the following model selection criteria: BIC-ICQ, BICh (hybrid BIC), and the regular BIC.
* "select_10Cov_var_restrict.R" - We use these simulations to illustrate the performance of our method using the initialization option "var_restrictions = 'fixef'", see "optimControl()" documentation for full details on the var_restrictions argument. Using the "var_restrictions = 'fixef'" option specifies that the random effect covariance matrix should be initialized in the following way: non-zero variance values are assigned to the random effect predictors that are given non-zero fixed effects coefficients during the initialization of the fixed effects coefficients. By reducing the number of random effects considered at the start of the algorthim, this can speed up the algorithm. This code re-runs the p=10 simulations specified in the paper using this "var_restrictions = 'fixef'" option.
* "select_50Cov_var_restrict.R" - Similar to "select_10Cov_var_restrict.R", this code re-runs the p=50 simulations specified in the paper using this "var_restrictions = 'fixef'" option.
* "select_10Cov_B2_alt.R" - This code re-runs the paper p=10 simulations using a larger value of the fixed effects coefficients (beta = 2 instead of beta = 1)
* "select_50Cov_B2_alt.R" - This code re-runs the paper p=50 simulations using a larger value of the fixed effects coefficients (beta = 2 instead of beta = 1)

Code to extract the relevant results from each set of simulations is given in corresponding "extract_results" R files:

* ...
