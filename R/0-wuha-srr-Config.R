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
library(lme4)
library(cowplot)
library(renv)
library(kableExtra)

#-------------------------------
# local file paths
#-------------------------------
box_data_path <- "~/Library/CloudStorage/Box-Box/trachoma-endgame/data"

