#libraries
library(ggplot2)
library(gtools)
library(dplyr)
library("seacarb", lib.loc="~/Library/R/3.3/library")

#Set working directory
setwd("/Users/paul.mcelhany/Documents/Ocean Acidification/Experiments/Pteropods/Pteropods 2016 pH x DO/Spec data/Spec pH CSV")

#List all files in that directory
file.names <- dir(getwd(),pattern=".csv")

#Create empty output file for new files to go into
Pteropod_2016_Specs <- NULL

#Create loop to go through all files and remove unnecessary columns
for (i in 1:length(file.names)){
  SpecTemp <- read.csv(file.names[i], stringsAsFactors = FALSE)
  SpecTemp2 <- SpecTemp[-1,-c(1,3:4,6:8,10:30)]
  
  Pteropod_2016_Specs <- smartbind(Pteropod_2016_Specs, SpecTemp2)
}

#Rename columns
colnames(Pteropod_2016_Specs)[1:3]<-c("MOATS","Date","pH")

#Put MOATS in sequence
moatsNames <- as.character(seq(1,13))

#Make MOATS a factor, and pH numeric
Pteropod_2016_Specs$MOATS<-factor(Pteropod_2016_Specs$MOATS, moatsNames)
Pteropod_2016_Specs$pH<-as.numeric(Pteropod_2016_Specs$pH) 
levels(Pteropod_2016_Specs$MOATS)

#Arrange columns by number (need to be resorted to go in numerical order??)
Pteropod_2016_Specs <- arrange(Pteropod_2016_Specs,MOATS)

#Remove empty rows
Pteropod_2016_Specs[Pteropod_2016_Specs==""] <- NA
Pteropod_2016_Specs <- na.omit(Pteropod_2016_Specs)

#Change DateTime format so R is happy
str(Pteropod_2016_Specs)
Pteropod_2016_Specs$NewDate <- as.POSIXct(strptime(Pteropod_2016_Specs$Date, "%e-%b-%y"))

#Add treatment column
lowMOATS <- c(1,4,5,8,10,11)
Pteropod_2016_Specs$Treatment <- "High"
Pteropod_2016_Specs$Treatment[Pteropod_2016_Specs$MOATS %in%lowMOATS] <- "Low"
View(Pteropod_2016_Specs)

######################################
## add temperature corrected pH
###################################

#input values
temperature <- 10
salinity <- 30

#function to calculate total alkalinty from salinity (Fassbender et al 2016)
calcTA <- function(S){
  return(47.7 * S + 647)
}

TA <- calcTA(salinity) * 1000000
DIC <- carb(flag = 8, Pteropod_2016_Specs$pH, TA, S = salinity, T = 25)$DIC

Pteropod_2016_Specs$pHinSitu <- carb(flag = 15, TA, DIC, S = salinity, T = temperature)$pH

View(Pteropod_2016_Specs)

###########################################################

#Calcuate mean and standard deviation for each MOATS
MOATS_Avg <- tapply(Pteropod_2016_Specs$pH, (Pteropod_2016_Specs$MOATS), mean)
MOATS_Std <- tapply(Pteropod_2016_Specs$pH, (Pteropod_2016_Specs$MOATS), sd)
MOATS_Stats <- cbind(MOATS_Avg, MOATS_Std)
colnames(MOATS_Stats) [1:2] <-c("Average pH", "Standard Deviation")
View(MOATS_Stats)

#Make graph function 
graphf <- function(df,moats){
  print(ggplot(subset(df,MOATS == moats), aes(NewDate, pH)) + geom_point(aes(colour = pH)) + 
          scale_colour_gradient(low = "blue") + ggtitle(paste("Moats",moats )) + xlab("Date"))
}
moatslist <- levels(Pteropod_2016_Specs$MOATS)

#Loop through all MOATS to create all 13 graphs
for(i in 1:length(moatslist)){
  graphf(Pteropod_2016_Specs,moatslist[i])
}

#Cool facetwrap graph
p <- ggplot(Pteropod_2016_Specs, aes(NewDate, pH, colour = pH)) + 
  geom_point() + ggtitle("All MOATS") + xlab("Time") +
  facet_wrap(~ MOATS)
p

#Pretty scatter plot of all MOATS
p <- ggplot(Pteropod_2016_Specs, aes(NewDate, pH))
p + ggtitle("All MOATS") + xlab("Time") + geom_point(aes(colour =MOATS))

#Basic box and whisker plot
p <- ggplot(Pteropod_2016_Specs, aes(MOATS, pH))
p + geom_boxplot()

#Function for computing mean, DS, max and min values
min.mean.sd.max <- function(x) {
  r <- c(min(x), mean(x) - sd(x), mean(x), mean(x) + sd(x), max(x))
  names(r) <- c("ymin", "lower", "middle", "upper", "ymax")
  r
}

# ggplot code
p1 <- ggplot(aes(y = pH, x = factor(MOATS)), data = Pteropod_2016_Specs)
p1 <- p1 + stat_summary(fun.data = min.mean.sd.max, geom = "boxplot") + geom_jitter(position=position_jitter(width=.2), size=3) + 
  ggtitle("pH of all MOATS with Standard Deviation") + xlab("MOATS") + ylab("pH")
p1

#Create a loop to go through all MOATS data and put outliers into separate table
mLevels <- levels(Pteropod_2016_Specs$MOATS)

theAnswer<-data.frame(NULL)

for(i in 1:length(mLevels)){
  dsub <- subset(Pteropod_2016_Specs, MOATS == mLevels[i])
  subout.Outlr<-boxplot.stats(dsub$pH)$out
  dSubout <- subset(dsub, pH %in% subout.Outlr)
  theAnswer <- rbind(theAnswer, dSubout)
}
View(theAnswer)
#Export data to Excel file
write.csv(Pteropod_2016_Specs, "C:/Users/Danielle.Perez/Documents/Pteropods/Pteropod_2016_Specs.csv")
write.csv(MOATS_Stats, "C:/Users/Danielle.Perez/Documents/Pteropods/MOATS_Stats.csv")
write.csv(theAnswer, "C:/Users/Danielle.Perez/Documents/Pteropods/MOATS Outliers.csv")
