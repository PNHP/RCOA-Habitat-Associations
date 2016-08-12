species = read.csv("Data_SF_all.csv", na.strings=c("NA"))
species$INFO_TAX_2_1[species$SNAME=="Cambarus monongalensis" & species$SUBNATION=="PA"] <- "Crayfishes"
write.csv(species, "Data_SF_all1.csv")