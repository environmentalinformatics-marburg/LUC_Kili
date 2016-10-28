# Resample Raster Data - create lookup table, resample testdata, resample trainingraster


library(raster)
library(plyr)
library(Rsenal)
library(caret)


scene <- 204# oder 802
filepath_base <- "/media/dogbert/XChange/Masterarbeit/LUC_Kili/"
#mainpath <- "/media/hanna/data/LUC_Kili/"

filepath_lookuptables <- paste0(filepath_base, "/classes/")
filepath_prediction <- paste0(filepath_base, "prediction/")
filepath_model <- paste0(filepath_base,"modeldata/")



look_up_df <- read.csv(paste0(filepath_lookuptables, "lookuptable_agg1.csv"))
pred_rst <- raster(paste0(filepath_prediction, "classification_", scene, ".tif"))
names(pred_rst)

reclassify(pred_rst, rcl = look_up_df, filename = paste0(filepath_prediction, names(pred_rst), "_agg1.tif"),
           overwrite = TRUE)

# reclassify test_data

load(paste0(filepath_model,"testData_",scene,".RData"))
colnames(look_up_df)<- c("class", "agg1")
testData <- join(testData,look_up_df,by='class')

load(paste0(filepath_model,"rfModel_",scene,".RData"))

head(testData)

prediction <- predict(model,testData[,names(model$trainingData)[-length(names(model$trainingData))]]) 

testData$prediction <-(as.numeric(as.character(prediction)))
colnames(look_up_df)<- c("prediction", "agg1_pred")
testData <- join(testData,look_up_df, by="prediction")

kappastat <- kstat(testData$agg1,testData$agg1_pred)
#########################################################


pred2_rst <- raster(paste0(filepath_prediction, "classification_", scene, "_agg.tif"))
names(pred2_rst)

look_up_df2 <- read.csv(paste0(filepath_lookuptables, "lookuptable_agg2.csv"))


reclassify(pred2_rst, rcl = look_up_df2, filename = paste0(filepath_prediction, names(pred_rst), "2.tif"),
           overwrite = TRUE)

head(look_up_df2)
colnames(look_up_df2)<- c("agg1", "agg2")

head(testData)
testData <- join(testData,look_up_df2,by='agg1')
colnames(look_up_df2)<- c("agg1_pred", "agg2_pred")
testData <- join(testData,look_up_df2,by='agg1_pred')

kappastat <- kstat(testData$agg2,testData$agg2_pred)







