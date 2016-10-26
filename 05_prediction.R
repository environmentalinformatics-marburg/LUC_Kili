library(raster)
library(caret)
# Read perfect sensor
scene <- 204 # oder 802
filepath_base <- "/media/hanna/data/LUC_Kili/"
filepath_model <- paste0(filepath_base,"modeldata/")
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")
filepath_results <- paste0(filepath_base,"results/")
filepath_prediction <- paste0(filepath_results,"prediction/")

########################

load(paste0(filepath_model,"rfModel_",scene,".RData"))
fls_sen <- c(list.files(paste0(filepath_raster, "merged_sentinel_bands" ), full.names = TRUE,pattern=".img$"),
             list.files(paste0(filepath_raster, "additional_bands"), full.names = TRUE,pattern=".img$"))

sen_st <- stack(fls_sen)
##########################
prediction <- predict(sen_st,model,progress="text")
writeRaster(prediction,paste0(filepath_prediction,"classification_",scene,".tif"))
