################################################################################
#Model training
################################################################################
mainpath <- "/media/memory01/data/hmeyer/LUC_Kili/"

library(doParallel)
library(caret)

load(paste0(mainpath,"datatrain_df.rda"))

train.df$class <- factor(train.df$class)

## Split data.frame into training and testing data
set.seed(500)

trainIndex <- createDataPartition(train.df$class, 
                                  p = 0.5,
                                  list = FALSE,
                                  times = 1)

trainData <- train.df[trainIndex,]
testData <- train.df[-trainIndex,]
save(testData,file=paste0(mainpath,"testData.RData"))

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
save(model,file=paste0(mainpath,"rfModel.RData"))