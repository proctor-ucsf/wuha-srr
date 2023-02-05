#---------------------------------
# 1-wuha-srr-data-processing.R
# 
# Pgp3 IgG decay and seroreversion
# in the WUHA trial, 0-36 months
#
# create the analysis dataset
#---------------------------------
      

#----------------------------
# source the project's
# configuration file
#----------------------------
library(here)
source(here("R/0-wuha-srr-Config.R"))

#----------------------------
# read in individual level
# trachoma antibody dataset
# from the longitudinal cohort
# within the WUHA trial
# 
# filter to children in the
# longitudinal cohort who
# were >0 years old
#----------------------------

# long data (one row per child per survey)
ind_all <- read_csv(here(box_data_path, "0-untouched/ethiopia-wuha-2016/20210923_wuha_ind_all.csv")) 

long_df <- ind_all %>% filter(longitudinal_cohort == 1) %>% filter(age_years>0)

#----------------------------
# create some derived variables
#----------------------------

#----------------------------
# a review of individual
# level IgG trajectories suggested
# that there could be some
# incorrectly mapped IgG responses
# After double-checking child
# records for blood, anthropometry
# and photos collected for photo
# grading, the study team (Isabel at UCSF)
# identified 27 instances where the
# study records appear to be mis-matched
# those children were removed from
# the present analysis
#
# the code below reads in
# two lists from these checks
# identifies the children
# and then drops them from
# the overall dataset that was
# read in above (ind_all)
#----------------------------
sero_drop_checks <- read_csv(here("data/0-untouched", "wuha_sero_drops.csv"))
sero_drop_checks_2 <- read_csv(here("data/0-untouched", "wuha_large_drops_to_check.csv"))

distinct_checks <- sero_drop_checks %>% dplyr::select(individual_id, verdict = `judgement call`) %>% 
  bind_rows(sero_drop_checks_2 %>% dplyr::select(individual_id, verdict) %>%
              # recode so that verdicts are same from both files
              mutate(verdict = case_when(
                verdict == "DIFFERENT" ~ "EXCLUDE",
                verdict == "SAME" ~ "KEEP",
                TRUE ~ verdict))) %>%
  distinct() %>%
  group_by(individual_id) %>%
  add_count() %>%
  ungroup()

# check for any discordant results between checks
#View(distinct_checks %>% filter(n>1) %>% arrange(individual_id))

# pull unique list of IDs to exclude
ids_exclude <- distinct_checks %>% 
  filter(verdict == "EXCLUDE" | verdict == "UNSURE") %>%
  pull(individual_id) %>%
  unique()
length(ids_exclude) # 27 unique kids to exclude


#----------------------------
# Data processing
#----------------------------

# select limited list of variables
df <- long_df %>% 
  dplyr::select(cluster_id, household_id, individual_id, survey, arm,
                age_months, age_years, sex, age_group, population=Population,
                pcr_individual, tf, ti, 
                pgp3_mfi = Pgp3, pgp3_pos = Pgp3_pos) %>% 
  # add Pgp3 cutoff value
  mutate(pgp3_cutoff = 1113) %>%
  # remove children who do not appear to be same child over time
  filter(!(individual_id %in% ids_exclude))

# identify children who seem to have entered the cohort at ages >5
df <- df %>%
  group_by(individual_id) %>%
  mutate(minage = min(age_years),
         maxage = max(age_years))

# print a cross-tab of min & max ages
age_tab <- df %>% slice(1) %>% ungroup()
table(age_tab$minage, age_tab$maxage)

# exclude 30 children who have minage > 5
table(age_tab$minage>5) # n= 30
df <- df %>%
  filter(minage <=5) %>%
  select(-minage, -maxage) %>%
  ungroup()

#----------------------------
# join the WUHA trial's 
# public IDs to de-identify
# the data for public release
#----------------------------
wuha_public_ids <- read_csv(here("data/2-final","wuha-0to36-public-ids.csv"))
df2 <- df %>%
  left_join(wuha_public_ids, by=c("cluster_id","household_id","individual_id")) %>%
  select(-cluster_id,-household_id,-individual_id) %>%
  select(cluster_id_public,household_id_public,individual_id_public,everything())

#----------------------------
# Save analysis dataset
#----------------------------
write_csv(df2, file = here("data/2-final","wuha-srr-analysis-dataset.csv"))
write_rds(df2, file = here("data/2-final","wuha-srr-analysis-dataset.rds"))


#----------------------------
# Session info
#----------------------------
sessionInfo()
