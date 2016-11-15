# Run init.r before other scripts
rm(list=ls())

 # set own relevant directory if working in R console, otherwise ignore if in terminal
setwd("/Users/davidbeauchesne/Dropbox/PhD/Misc/SurveyTool/Survey")
# -----------------------------------------------------------------------------
# PROJECT:
#    Survey tool that automatically generates results for conference use
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# FUNCTIONS:

# -----------------------------------------------------------------------------
# install.packages("shiny")
# install.packages("rdrop2")
# install.packages("stringr")
library(shiny)
runApp()
