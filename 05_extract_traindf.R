# Extracts the trainingpixels from the trainingshapefile + the perfect_sensor Rasterstack


library(raster)
library(rgdal)
library(caret)
library(Rsenal)

scene <- 802# oder 204
filepath_base <- "/media/dogbert/XChange/Masterarbeit/LUC_Kili/"
#mainpath <- "/media/hanna/data/LUC_Kili/"
filepath_model <- paste0(filepath_base,"modeldata/")
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")
filepath_vector <- paste0(filepath_base,"vector/scene_",scene,"/")

all_tr_areas <-  readOGR(paste0(filepath_vector,"all_tr_areas/all_training_areas.shp"), 
                         layer = "all_training_areas")

all_tr_areas <- all_tr_areas[all_tr_areas$DN != 57,]
all_tr_areas <- all_tr_areas[all_tr_areas$DN != 58,]
all_tr_areas <- all_tr_areas[all_tr_areas$DN != 59,]
all_tr_areas <- all_tr_areas[all_tr_areas$DN != 63,]
all_tr_areas <- all_tr_areas[all_tr_areas$DN != 64,]
writeOGR(all_tr_areas, paste0(filepath_vector,"/trainingsites_cleaned/cleaned_trainingsites.shp"), 
        layer = "cleaned_trainingsites", driver = "ESRI Shapefile")
# die klasse 57 für wolken wird manuell nach diesem befehl hinzugefügt


# read shapelayer training sites
trainingsites <- readOGR(paste0(filepath_vector,"/trainingsites_cleaned/cleaned_trainingsites.shp"), 
                         layer = "cleaned_trainingsites")
# get projection of Landsat and training sites
load(paste0(filepath_raster,"perfect_sensor.rda"))


projection(perfect_sensor)
projection(trainingsites)
spTransform(trainingsites, crs(perfect_sensor))

train.df <- extract(perfect_sensor, trainingsites, df = TRUE)

summary(train.df)

# add a new column to the data.frame that includes the land cover 
# information from the training site shapefiles
trainingsites$DN[1] # class name of the first poygon
train.df$class <- trainingsites$DN[train.df$ID]
head(train.df)

save(train.df, file = paste0(filepath_model,"datatrain_df_",scene,".rda"))
