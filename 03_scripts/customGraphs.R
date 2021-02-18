library(ggplot2)

#importantcomment

setwd("/Users/paul.mcelhany/Downloads")
d <- read.csv("SpecData (49).csv", stringsAsFactors = FALSE)
d$date <- as.POSIXct(strptime(d$date, "%Y-%m-%d"))

unique(d$unit_ID)


dsub <- subset(d, unit_ID == "Chamber_5")
dsub2 <- d[d$unit_ID == "Chamber_6",]

ggplot(d, aes(date, pHinsitu, colour = unit_ID)) +
  geom_point()


