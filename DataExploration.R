tab_uniq_SF <- subset(species, !duplicated(species$SHAPE_JOIN))

tab_count_SNAME <- as.data.frame(table(tab_uniq_SF$SNAME))
names(tab_count_SNAME) <- c("SNAME","COUNT")

tab_count_HUC08 <- as.data.frame(table(tab_uniq_SF$HUC8))
names(tab_count_HUC08) <- c("HUC8","COUNT")
write.csv(tab_count_HUC08, "count_HUC08.csv")

tab_count_ECOREGION <- as.data.frame(table(tab_uniq_SF$ECOREGION))
names(tab_count_ECOREGION) <- c("ECOREGION","COUNT")
write.csv(tab_count_ECOREGION, "count_ECOREGION.csv")

tab_count_ECO_CODE <- as.data.frame(table(tab_uniq_SF$ECO_CODE))
names(tab_count_ECO_CODE) <- c("ECO_CODE","COUNT")
write.csv(tab_count_ECO_CODE, "count_ECO_CODE.csv")