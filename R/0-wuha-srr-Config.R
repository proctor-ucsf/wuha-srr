#----------------------------
# 0-wuha-srr-Config.R
#
# Configuration file for the
# WUHA study longitudinal 
# analysis of seroconversion
# and seroreversion (SRR)
# 
# based on Ct Pgp3 IgG
#----------------------------

#----------------------------
# load required packages
#----------------------------
library(here)
library(tidyverse)
library(ggplot2)
library(cowplot)
library(renv)
library(kableExtra)
library(table1)

# statistics packages
library(lme4)
library(foreach)
library(doParallel)
registerDoParallel(detectCores() - 1)


#-------------------------------
# local file paths
#-------------------------------
box_data_path <- "~/Library/CloudStorage/Box-Box/trachoma-endgame/data"

