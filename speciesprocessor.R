library(reshape)
library(data.table)
library(plyr)

tempspecies = read.csv("Data_SF_all.csv", na.strings=c("NA"))

> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,1)=="P"] <- "Flowering Plants"
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="AB"] <- "Birds"
> View(tempspecies)
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="AA"] <- "Amphibians"
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="AM"] <- "Mammals"
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="II"] <- "Dragonflies and Damselflies"
> View(tempspecies)
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="AF"] <- "Freshwater and Anadromous Fishes"
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,5)=="IMBIV"] <- "Freshwater Mussels"
> View(tempspecies)
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="IL"] <- "Spiders and other Chelicerates"
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,2)=="AR"] <- "Reptiles"
> View(tempspecies)
> tempspecies$INFO_TAX_1[tempspecies$INFO_TAX_1=="0" & substr(tempspecies$ELCODE_1,1,5)=="IMGAS"] <- "Terrestrial Snails"
> View(tempspecies)

write.csv(tempspecies, "Data_SF_all.csv")
