library(stringr)
library(data.table)
library(plyr)

Weight_DSLDist_All <- read.csv("20160720_FinalResults\\OutputWeights_DSL-Dist_All.csv", na.strings=c("NA"))
Weight_DSLDist_All <- droplevels(subset(Weight_DSLDist_All,weight!=0.0000))
Weight_DSLDist_SGCN <- read.csv("20160720_FinalResults\\OutputWeights_DSL-Dist_SGCN.csv", na.strings=c("NA"))
Weight_DSLDist_SGCN <- droplevels(subset(Weight_DSLDist_SGCN,weight!=0.0000))

Weight_DSLDistHUC6_All <- read.csv("20160720_FinalResults\\OutputWeights_DSL-Dist-HUC6_All.csv", na.strings=c("NA"))
Weight_DSLDistHUC6_All <- droplevels(subset(Weight_DSLDistHUC6_All,weight!=0.0000))
Weight_DSLDistHUC6_All$HUC6 <- str_sub(Weight_DSLDistHUC6_All$habitatcode, start= -6) # pulls out the HUC6 for grouping later
Weight_DSLDistHUC6_All$habitatcode1 <- gsub("^([^_]*_[^_]*)_.*$", "\\1",Weight_DSLDistHUC6_All$habitatcode)
Weight_DSLDistHUC6_SGCN <- read.csv("20160720_FinalResults\\OutputWeights_DSL-Dist-HUC6_SGCN.csv", na.strings=c("NA"))
Weight_DSLDistHUC6_SGCN <- droplevels(subset(Weight_DSLDistHUC6_SGCN,weight!=0.0000))
Weight_DSLDistHUC6_SGCN$HUC6 <- str_sub(Weight_DSLDistHUC6_SGCN$habitatcode, start= -6) # pulls out the HUC6 for grouping later
Weight_DSLDistHUC6_SGCN$habitatcode1 <- gsub("^([^_]*_[^_]*)_.*$", "\\1",Weight_DSLDistHUC6_SGCN$habitatcode)

# quantile score the REGIONAL layers
## All species
Weight_DSLDist_All$WeightQuantile <- with(Weight_DSLDist_All, .bincode(weight, breaks=qu <- quantile(weight, probs=seq(0,1,0.01),
                               na.rm=TRUE),(labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], 
                               include.lowest=TRUE))
Weight_DSLDist_All$WeightQuantile <- as.numeric(Weight_DSLDist_All$WeightQuantile)

## Just SGCN
Weight_DSLDist_SGCN$WeightQuantile <- with(Weight_DSLDist_SGCN, .bincode(weight, breaks=qu <- quantile(weight, probs=seq(0,1,0.01),
                               na.rm=TRUE),(labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], 
                               include.lowest=TRUE))
Weight_DSLDist_SGCN$WeightQuantile <- as.numeric(Weight_DSLDist_SGCN$WeightQuantile)


# this stuff below deals with the quantiles within groups.
# function to get quantiles
qfun <- function(x, q=100) {
  quantile <- .bincode(x, breaks=sort(quantile(x, probs=0:q/q)), right=TRUE,include.lowest=TRUE)
  quantile
}

#quantile it
Weight_DSLDistHUC6_All$q <- ave(Weight_DSLDistHUC6_All$weight,Weight_DSLDistHUC6_All$HUC6,FUN=qfun)
Weight_DSLDistHUC6_SGCN$q <- ave(Weight_DSLDistHUC6_SGCN$weight,Weight_DSLDistHUC6_SGCN$HUC6,FUN=qfun)

# join it
Weight_DSLDist_All_JOIN <- merge(Weight_DSLDistHUC6_All, Weight_DSLDist_All, by.x="habitatcode1", by.y="habitatcode", sort = FALSE)
Weight_DSLDist_All_JOIN$SUM <-Weight_DSLDist_All_JOIN$WeightQuantile  + Weight_DSLDist_All_JOIN$q

Weight_DSLDist_SGCN_JOIN <- merge(Weight_DSLDistHUC6_SGCN, Weight_DSLDist_SGCN, by.x="habitatcode1", by.y="habitatcode", sort = FALSE)
Weight_DSLDist_SGCN_JOIN$SUM <-Weight_DSLDist_SGCN_JOIN$WeightQuantile  + Weight_DSLDist_SGCN_JOIN$q

# make a final file for joining to the GIS
FinalWeight_DSLDist <- Weight_DSLDist_All_JOIN[,!(names(Weight_DSLDist_All_JOIN) %in% 
                      c("X.x","weight.x","HUC6","q","X.y","weight.y","hab_class_name.y","WeightQuantile"))]   # drop a bunch of columns
setnames(FinalWeight_DSLDist,"SUM","AllSpecies")
TempWeight_DSLDist_SGCN_JOIN <- Weight_DSLDist_SGCN_JOIN[,!(names(Weight_DSLDist_SGCN_JOIN) %in% 
                                                    c("X.x","weight.x","HUC6","q","X.y","weight.y","hab_class_name.x","habitatcode1","hab_class_name.y","WeightQuantile"))]   # drop a bunch of columns
setnames(TempWeight_DSLDist_SGCN_JOIN,"SUM","SGCN")


FinalWeight_DSLDist <- merge(FinalWeight_DSLDist, TempWeight_DSLDist_SGCN_JOIN, by="habitatcode", sort=FALSE)
FinalWeight_DSLDist$Difference <- FinalWeight_DSLDist$AllSpecies-FinalWeight_DSLDist$SGCN
summary(FinalWeight_DSLDist$Difference)

write.csv(FinalWeight_DSLDist, "FinalWeight_DSLDist.csv")





