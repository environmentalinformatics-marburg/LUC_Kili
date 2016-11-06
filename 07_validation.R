# validation of the random forest model

rm(list=ls())
library(Rsenal)
library(caret)

scene <- 802# oder 802
filepath_base <- "/media/dogbert/XChange/Masterarbeit/LUC_Kili"
#mainpath <- "/media/hanna/data/LUC_Kili/"

filepath_model <- paste0(filepath_base,"modeldata/")
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")
filepath_results <- paste0(filepath_base,"results/")
filepath_validation <- paste0(filepath_results,"validation/")
#dir.create(filepath_validation)

load(paste0(filepath_model,"testData_",scene,".RData"))
load(paste0(filepath_model,"rfModel_",scene,".RData"))
prediction <- predict(model,testData)
kappastat <- kstat(testData$class,prediction)
write.csv(kappastat,paste0(filepath_validation,"kstat_",scene,".csv"))
##missing: validation on different aggregation levels