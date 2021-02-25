
#
#   Hello World
# 
# Author: OA Lab, NWFSC
# Title: Salmon Shed Tanks_rbind all UDA tank data
# Date: 2018-2019 (R document January-February 2021)

#set working directory to the correct folder
setwd("/Users/katherinerovinski/GIT/NWFSC.MUK_DGNjuvenile.tanks")

# 1.) Water Chemistry
#### 1.1) pH plots per tank timeseries
#*********************************
## 1.1) pH plots -Timeseries Plots - Bringing Together UDA plots for the different tanks
#*********************************




UDAtank01 <- read.csv(file = "Tank01UDALog.csv", stringsAsFactors = FALSE)
UDAtank02 <- read.csv(file = "Tank02UDALog.csv", stringsAsFactors = FALSE)
UDAtank04 <- read.csv(file = "Tank04UDALog.csv", stringsAsFactors = FALSE)
UDAtank05 <- read.csv(file = "Tank05UDALog.csv", stringsAsFactors = FALSE)
UDAtank06 <- read.csv(file = "Tank06UDALog.csv", stringsAsFactors = FALSE)

pHdtankUDA <- rbind(UDAtank06,
                    UDAtank05,  
                    UDAtank04,
                    UDAtank02,
                    UDAtank01)

#|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
#*********************************
## 2.0) Output File
#*********************************

write.csv(pHdtankUDA, "2021.02.18_pH_Salinity_UDA.csv")

#|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |



#**************E*N*D*************# 
#*********************************
## END OF SCRIPT | END OF DOCUMENT 
#*********************************


