# This script poligonizes the idrisi Trainingareas to shapefiles - uses 00_sen_fun.R

library(caret)
library(rgdal)
library(raster)

scene <- 802# oder 802
filepath_base <- "/media/dogbert/XChange/Masterarbeit/LUC_Kili/"



filepath_code <- paste0(filepath_base,"code/LUC_Kili/")
filepath_vector <- paste0(filepath_base,"vector/scene_",scene,"/")
source(paste0(filepath_code,"00_sen_fun.R"))

fls_idrisi <- list.files(paste0(filepath_base,"vector/Idrisi_rst"), full.names = TRUE, pattern ="rst")


for (i in seq(1,length(fls_idrisi))){
  print(i)
  idrisi_rst <- raster(fls_idrisi[i])
  gdal_polygonizeR(idrisi_rst, outshape = paste0(filepath_vector,"poligonized_shps/", names(idrisi_rst)))
}

fls_shp <- list.files(paste0(filepath_vector,"poligonized_shps/"), full.names = FALSE, pattern =".shp")
fls_shp <- gsub(".shp", "", fls_shp)

#merge all training areas together

all_tr_areas <- readOGR(dsn = paste0(filepath_vector,"poligonized_shps/",fls_shp[1],".shp"), layer = fls_shp[1])

nrw <- c(nrow(all_tr_areas@data))

for (i in seq(2,length(fls_shp))){
  print(i)
  act_shape <- readOGR(dsn = paste0(filepath_vector,"poligonized_shps/",fls_shp[i],".shp"), layer = fls_shp[i])
  if (nrow(act_shape@data) >= 400){
    part_O <- createDataPartition(act_shape@data$DN, p=0.33, 
                                  list=TRUE, groups= 8)
    part_O <- as.vector(part_O$Resample1)
    act_shape <- act_shape[part_O,]
  }
  
  nrw <- c(nrw,nrow(act_shape@data))
  all_tr_areas <- union(all_tr_areas, act_shape) 
}

setwd(paste0(filepath_vector, "all_tr_areas/"))
writeOGR(all_tr_areas, "all_tr_areas", 
         layer= "all_training_areas",driver = "ESRI Shapefile", overwrite_layer = TRUE)

# after poligonizing the rasters they have to be cleand manually! 
# delete all trainingareas which are in clouds/shadow 
# add training areas for clouds


