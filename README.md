# Introduction and Installation

This GitHub repository contains the example code, simulation materials, and supplemental results discussed within the paper "glmmPen: High Dimensional Penalized Generalized Linear Mixed Models" by Heiling et al., which describes the glmmPen R package method. This paper has been submitted to the R Journal and has been uploaded to the ArXiv online journal.

The code to run the glmmPen_FA method is provided in the glmmPen R package available on CRAN at https://cran.r-project.org/web/packages/glmmPen/index.html and is also available in the GitHub respository https://github.com/hheiling/glmmPen.

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

The "heiling-glmmPen.R" code runs the primary example given in the paper, which uploads the 'basal' dataset provided within the package, specifies a generalized linear mixed model with 10 covariates, and performs variable selection on the fixed and random effects of this model. This code also applies several S3 method functions to the fit object created from this example and uses this output to replicate the figures given within the paper. The simulations discussed in the paper would take a long time to run, so this code reads in RData objects with summary results from these simulations and uses these results to replicate the tables given within the paper.

In order to replicate the code output, tables, and figures within the paper, run the following R code:
```
# Set working directory to Replication/ folder contents
## ... (to be continued)
```

### RData files 

The RData files provided in this folder contain output from the simulations discussed in the paper. As a result, users of this repo can replicate the tables summarizing the simulation results without having to run all of the simulations themselves, which take some time to run. 

### "heiling-glmmPen-extra.R" 

The "hheiling-glmmPen-extra.R" code runs a secondary code example given in the paper, which uploads the 'basal' dataset provided within the package, specifies a generalized linear mixed model with 10 covariates, and fits a single generalized linear model with no penalization applied to the fixed or random effects.

In order to run this secondary code example, run the following R code:
```
# Set working directory to Replication/ folder contents
## ... (to be continued)
```

### Simulation code

The subfolders "sims_on_cluster" and "sims_serial" contain the code to re-run the simulations presented in the paper.

The folder "sims_on_cluster" contains the code needed to run the simulation replicates in parallel on a computing cluster.

Linux code to submit the jobs to a computing cluster:
```

```

The folder "sims_serial" contains the code needed to run the simulation replicates in serial. Warning: Running all p=50 simulations in serial will take a very long time. We highly recommend running all simulations in parallel on a computing cluster.

R code to run the simulations in serial:
```

```


# Suppplement

In our paper, we make some claims and recommendations based on empirical results we have observed in simulations which are not directly reported within the paper due to space considerations. To support some of our paper discussions, we present additional code and materials within the Supplement/ folder.

For each simulation of interest, we provide 4 items:

* Code to run the simulations
* Code to extract relevant simulation output
* RData file that contains the relevant simulation output
* Code to create summary plots or statistics 

... (to be continued)
