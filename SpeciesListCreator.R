#---------------------------------------------------------------------------------------------
# Name: HabitatAssociations.R
# Purpose: 
# Author: Christopher Tracey
# Created: 2016-06-23
# Updated: 2016-06-24
#
# Updates:
# insert date and info
# * 2016-06-23 - created script
# * 2016-06-24 - added in quantile scaling
#
# To Do List/Future Ideas:
# * add some "jitter" to the quantile scoring
# * compact the code up a little.
#---------------------------------------------------------------------------------------------

library(reshape)
library(data.table)
library(plyr)

#load in species lists, rename, etc
masterlist <- read.csv("_RSGCN_for_associations.csv")
masterlist <- masterlist[,!(names(masterlist) %in% c("X","X.1","X.2","X.3","X.4","X.5"))]
setnames(masterlist,"X1..ALLOWED.all.species..n.3016..19..","All")
setnames(masterlist,"X1..ALLOWED.SGCN..n.1062..44..","SGCN")
setnames(masterlist,"X1..ALLOWED..hockeystick...n.978..54..","Hockeystick")
setnames(masterlist,"X1..ALLOWED..high.high...n.476..60..","HighHigh")

# subset to different lists for use in HabitatAssociations.R ---------------------------------

# all species
SpeciesList_All <- droplevels(subset(masterlist,All==1))
SpeciesList_All$TSS.quant <- with(SpeciesList_All, cut(RAW.TSS.RANK, breaks=qu <- quantile(RAW.TSS.RANK, probs=seq(0,1,0.1)),
               (labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], include.lowest=FALSE))

# SGCN
SpeciesList_SGCN <- droplevels(subset(masterlist,SGCN==1))
SpeciesList_SGCN$TSS.quant <- with(SpeciesList_SGCN, cut(RAW.TSS.RANK, breaks=qu <- quantile(RAW.TSS.RANK, probs=seq(0,1,0.2)),
               (labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], include.lowest=FALSE))

# Hockeystick
SpeciesList_Hockeystick <- droplevels(subset(masterlist,Hockeystick==1))
SpeciesList_Hockeystick$TSS.quant <- with(SpeciesList_Hockeystick, cut(RAW.TSS.RANK, breaks=qu <- quantile(RAW.TSS.RANK, probs=seq(0,1,0.2)),
               (labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], include.lowest=FALSE))

# High and High
SpeciesList_HighHigh <- droplevels(subset(masterlist,HighHigh==1))
SpeciesList_HighHigh$TSS.quant <- with(SpeciesList_HighHigh, cut(RAW.TSS.RANK, breaks=qu <- quantile(RAW.TSS.RANK, probs=seq(0,1,0.50)),
                (labels=(as.numeric(gsub("%.*","",names(qu))))/100)[-1], include.lowest=FALSE))






