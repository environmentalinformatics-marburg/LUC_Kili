# Trains a random forest model 


################################################################################
#Model training
################################################################################
scene <- 204# oder 802
filepath_base <- "/media/memory01/data/hmeyer/LUC_Kili/"
#mainpath <- "/media/hanna/data/LUC_Kili/"

filepath_model <- paste0(filepath_base,"modeldata/")
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")
filepath_results <- paste0(filepath_base,"results/")
filepath_prediction <- paste0(filepath_results,"prediction/")

library(doParallel)
library(caret)

load(paste0(filepath_model,"datatrain_df_",scene,".rda"))

train.df$class <- factor(train.df$class)

## Split data.frame into training and testing data
set.seed(500)

trainIndex <- createDataPartition(train.df$class, 
                                  p = 0.5,
                                  list = FALSE,
                                  times = 1)

trainData <- train.df[trainIndex,]
testData <- train.df[-trainIndex,]
save(testData,file=paste0(filepath_model,"testData_",scene,".RData"))

### define predictors and response
predictors <- trainData[,2:17]
response <- trainData$class

set.seed(500)
cvindex <- createFolds(trainData$class)
ctrl <- trainControl(index=cvindex,
                     method="cv")

### train a random forest model

cl <- makeCluster(detectCores()-6)
registerDoParallel(cl)
set.seed(500)
model <- train(predictors, response, method = "rf",
               tuneLength = 5, trControl=ctrl)
stopCluster(cl)
save(model,file=paste0(filepath_model,"rfModel_",scene,".RData"))