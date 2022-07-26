library(readxl)
library(tidyverse)
USDA_milk_study_data_2_11_22 <- read.csv("milk_onetime.csv")
View(USDA_milk_study_data_2_11_22)
calfweight <- select(USDA_milk_study_data_2_11_22, c(cowID, milkAUC, cowagen, cdate, seasonyr, calfbirth, calf30, calf60, calf90, calf120, calfwean, calfsex))

calfweightlong <- calfweight %>% gather(key = day, value=calfweight, calfbirth:calfwean)
calfweightlong$day[calfweightlong$day=="calfbirth"] <- 0
calfweightlong$day[calfweightlong$day=="calf30"] <- 30
calfweightlong$day[calfweightlong$day=="calf60"] <- 60
calfweightlong$day[calfweightlong$day=="calf90"] <- 90
calfweightlong$day[calfweightlong$day=="calf120"] <- 120
calfweightlong$day[calfweightlong$day=="calfwean"] <- 200
View(calfweightlong)

cowBW <- select(USDA_milk_study_data_2_11_22, c(cowID, seasonyr, milkAUC, cowagen, cdate, precalveBW, prebreedBW, breedBW, weanBW, calfsex))
cowBWlong <- cowBW %>% gather(key = stage, value=BW, precalveBW:weanBW)
cowBWlong$stage[cowBWlong$stage=="precalveBW"] <- "precalve"
cowBWlong$stage[cowBWlong$stage=="prebreedBW"] <- "prebreed"
cowBWlong$stage[cowBWlong$stage=="breedBW"] <- "breed"
cowBWlong$stage[cowBWlong$stage=="weanBW"] <- "wean"
View(cowBWlong)

cowBCS <- select(USDA_milk_study_data_2_11_22, c(cowID, seasonyr, milkAUC, cowagen, cdate, precalveBCS, prebreedBCS, breedBCS, weanBCS, calfsex))
cowBCSlong <- cowBCS %>% gather(key = stage, value=BCS, precalveBCS:weanBCS)
cowBCSlong$stage[cowBCSlong$stage=="precalveBCS"] <- "precalve"
cowBCSlong$stage[cowBCSlong$stage=="prebreedBCS"] <- "prebreed"
cowBCSlong$stage[cowBCSlong$stage=="breedBCS"] <- "breed"
cowBCSlong$stage[cowBCSlong$stage=="weanBCS"] <- "wean"
View(cowBCSlong)

df <- select(cowBWlong, BW)
BWBC <- cbind(cowBCSlong, df)
View(BWBC)

write.csv(BWBC, "cow_bwbcs.csv", row.names = FALSE)
write.csv(calfweightlong, "/Users/ojt/Desktop/calfweights.csv", row.names = FALSE)
