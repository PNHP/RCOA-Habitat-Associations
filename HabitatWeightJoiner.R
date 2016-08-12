OutputWeights_All <- read.csv("OutputWeights_All.csv")
OutputWeights_SGCN <- read.csv("OutputWeights_SGCN.csv")
OutputWeights_Hockeystick <- read.csv("OutputWeights_Hockeystick.csv")
OutputWeights_HighHigh <- read.csv("OutputWeights_HighHigh.csv")

habitat_weights1 <- join(OutputWeights_All,OutputWeights_SGCN ,by=c('habitatcode'))
habitat_weights2 <- join(habitat_weights1,OutputWeights_Hockeystick ,by=c('habitatcode'))
habitat_weights <- join(habitat_weights2,OutputWeights_HighHigh ,by=c('habitatcode'))

habitat_weights_join <- subset(habitat_weights, select=c("habitatcode", "weight_All", 
                        "weight_SGCN", "weight_Hockeystick", "weight_HighHigh"))

write.csv(habitat_weights_join,"join_habitat_weights.csv")
