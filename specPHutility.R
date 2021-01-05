#utility for various spec pH stats


#input to this utility is the output download file from the specPH shiny app
library(rcompanion)
setwd("/Users/paul.mcelhany/Downloads")
d <- read.csv("SpecData (46).csv", stringsAsFactors = FALSE)

#Get the mean and CI for tank pH by treatment
tankCI <- groupwiseMean(pHinsitu ~ treatName, data = subset(d, unit == "Tank"), conf  = 0.95, digits = 3)
tankCI
