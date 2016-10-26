###validation
rm(list=ls())
library(Rsenal)
library(caret)
mainpath <- "/media/memory01/data/hmeyer/LUC_Kili/"

load(paste0(mainpath,"testData.RData"))
load(paste0(mainpath,"model.RData"))
prediction <- predict(model,testData)
kappastat <- kstat(testData$class,prediction)
write.csv(kappastat,paste0(mainpath,"kstat.csv"))
##missing: validation on different aggregation levels