


#—————————————————-----------------
# 0-wuha-srr-RUNALL.sh
# 
# shell script to run
# all scripts in the
# WUHA Pgp3 seroreversion analysis
#—————————————————-----------------

# Make public analysis dataset
# (will not run in public files — included for transparency)
R CMD BATCH 1-wuha-srr-data-processing.R 

# Make public dataset codebook
Rscript -e "rmarkdown::render('2-make-codebook-wuha-srr-analysis-dataset.Rmd')"

# Run analysis file
Rscript -e "rmarkdown::render('3-wuha-srr-analysis.Rmd')"

