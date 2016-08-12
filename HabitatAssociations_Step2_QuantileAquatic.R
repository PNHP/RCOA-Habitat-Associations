library(stringr)
library(data.table)
library(plyr)

Weight_NEAHC_All <- read.csv("20160720_FinalResults\\AquaticWeights_NEAHC_ALL.csv", na.strings=c("NA"))
Weight_NEAHC_All <- droplevels(subset(Weight_NEAHC_All,weight!=0.0000))
Weight_NEAHC_SGCN <- read.csv("20160720_FinalResults\\AquaticWeights_NEAHC_SGCN.csv", na.strings=c("NA"))
Weight_NEAHC_SGCN <- droplevels(subset(Weight_NEAHC_SGCN,weight!=0.0000))

Weight_NEAHCHUC6_All <- read.csv("20160720_FinalResults\\AquaticWeights_NEAHC_HUC6_ALL.csv", na.strings=c("NA"))
Weight_NEAHCHUC6_All <- droplevels(subset(Weight_NEAHCHUC6_All,weight!=0.0000))
Weight_NEAHCHUC6_All$HUC6 <- str_sub(Weight_NEAHCHUC6_All$habitatcode, start= -6) # pulls out the HUC6 for grouping later
Weight_NEAHCHUC6_All$habitatcode1 <- str_sub(Weight_NEAHCHUC6_All$habitatcode, start= 1,end=7)#gsub("^([^_]*_[^_]*)_.*$", "\\1",Weight_NEAHCHUC6_All$habitatcode)
Weight_NEAHCHUC6_SGCN <- read.csv("20160720_FinalResults\\AquaticWeights_NEAHC_HUC6_SGCN.csv", na.strings=c("NA"))
Weight_NEAHCHUC6_SGCN <- droplevels(subset(Weight_NEAHCHUC6_SGCN,weight!=0.0000))
Weight_NEAHCHUC6_SGCN$HUC6 <- str_sub(Weight_NEAHCHUC6_SGCN$habitatcode, start= -6) # pulls out the HUC6 for grouping later
Weight_NEAHCHUC6_SGCN$habitatcode1 <- str_sub(Weight_NEAHCHUC6_SGCN$habitatcode, start= 1,end=7)#gsub("^([^_]*_[^_]*)_.*$", "\\1",Weight_NEAHCHUC6_SGCN$habitatcode)

# quantile score the REGIONAL layers
## All species
Weight_NEAHC_All$WeightQuantile <- with(Weight_NEAHC_All, .bincode(weight, breaks=qu <- quantile(weight, probs=seq(0,1,0.01),
                               na.rm=TRUE),(labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], 
                               include.lowest=TRUE))
Weight_NEAHC_All$WeightQuantile <- as.numeric(Weight_NEAHC_All$WeightQuantile)

## Just SGCN
Weight_NEAHC_SGCN$WeightQuantile <- with(Weight_NEAHC_SGCN, .bincode(weight, breaks=qu <- quantile(weight, probs=seq(0,1,0.01),
                               na.rm=TRUE),(labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], 
                               include.lowest=TRUE))
Weight_NEAHC_SGCN$WeightQuantile <- as.numeric(Weight_NEAHC_SGCN$WeightQuantile)


# this stuff below deals with the quantiles within groups.
# function to get quantiles
qfun <- function(x, q=100) {
  quantile <- .bincode(x, breaks=sort(quantile(x, probs=0:q/q)), right=TRUE,include.lowest=TRUE)
  quantile
}

#quantile it
Weight_NEAHCHUC6_All$q <- ave(Weight_NEAHCHUC6_All$weight,Weight_NEAHCHUC6_All$HUC6,FUN=qfun)
Weight_NEAHCHUC6_SGCN$q <- ave(Weight_NEAHCHUC6_SGCN$weight,Weight_NEAHCHUC6_SGCN$HUC6,FUN=qfun)

# join it
Weight_NEAHC_All_JOIN <- merge(Weight_NEAHCHUC6_All, Weight_NEAHC_All, by.x="habitatcode1", by.y="habitatcode", sort = FALSE)
Weight_NEAHC_All_JOIN$SUM <-Weight_NEAHC_All_JOIN$WeightQuantile  + Weight_NEAHC_All_JOIN$q

Weight_NEAHC_SGCN_JOIN <- species <- merge(Weight_NEAHCHUC6_SGCN, Weight_NEAHC_SGCN, by.x="habitatcode1", by.y="habitatcode", sort = FALSE)
Weight_NEAHC_SGCN_JOIN$SUM <-Weight_NEAHC_SGCN_JOIN$WeightQuantile  + Weight_NEAHC_SGCN_JOIN$q

# make a final file for joining to the GIS
FinalWeight_NEAHC <- Weight_NEAHC_All_JOIN[,!(names(Weight_NEAHC_All_JOIN) %in% 
                      c("X.x","weight.x","HUC6","q","X.y","weight.y","hab_class_name.y","WeightQuantile"))]   # drop a bunch of columns
setnames(FinalWeight_NEAHC,"SUM","AllSpecies")
TempWeight_NEAHC_SGCN_JOIN <- Weight_NEAHC_SGCN_JOIN[,!(names(Weight_NEAHC_SGCN_JOIN) %in% 
                                                    c("X.x","weight.x","HUC6","q","X.y","weight.y","hab_class_name.x","habitatcode1","hab_class_name.y","WeightQuantile"))]   # drop a bunch of columns
setnames(TempWeight_NEAHC_SGCN_JOIN,"SUM","SGCN")


FinalWeight_NEAHC <- merge(FinalWeight_NEAHC, TempWeight_NEAHC_SGCN_JOIN, by="habitatcode", sort=FALSE)
FinalWeight_NEAHC$Difference <- FinalWeight_NEAHC$AllSpecies-FinalWeight_NEAHC$SGCN
summary(FinalWeight_NEAHC$Difference)

write.csv(FinalWeight_NEAHC, "FinalWeight_NEAHC.csv")





