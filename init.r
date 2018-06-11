# Run init.r before other scripts
rm(list=ls())
 # for use in R console.
 # set own relevant directory if working in R console, otherwise ignore if in terminal
setwd("/Users/davidbeauchesne/Dropbox/PhD/Misc/SurveyTool")
# -----------------------------------------------------------------------------
# PROJECT:
#    Survey tool that automatically generates results for conference use
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# FUNCTIONS:

# -----------------------------------------------------------------------------
# install.packages("shiny")
# install.packages("rdrop2")
#  install.packages("stringr")
setwd("./Survey")

# To initialize survey without any results
# Change loadData.r if I want to have more than 16 bars set aside in the plot
total_team <- 16
plot_table <- data.frame(name = '', Total = rep(0, total_team))

saveRDS(plot_table, file = './plot_table.RDS')

# To deploy app on shinyserver.io
library(rsconnect)
rsconnect::setAccountInfo(name='david-beauchesne', token='9E726A003F62EB18DAC88CFF483BD975', secret='5bdikPCf2o2tqne7QwpqVe7OajvxqaFwJ5JyDgc/')
deployApp()
