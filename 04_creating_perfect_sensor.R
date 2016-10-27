# creates a rasterstack where all sentinel bands + artificial images + pca + ndvi are avaialble

library(raster)

scene <- 204# oder 802
filepath_base <- "/media/benjamin/XChange/Masterarbeit/LUC_Kili/"
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")



# read in rest of the data
fls_add <- list.files(paste0(filepath_raster, "additional_bands"), 
                      full.names = TRUE)
fls_bands <- list.files(paste0(filepath_raster,"merged_sentinel_bands"), 
                        full.names = TRUE)


add_st <- stack(fls_add)
bands_st <- stack(fls_bands)


perfect_sensor <- stack(add_st,bands_st)
load(perfect_sensor, paste0(filepath_raster,"perfect_sensor.rda"))

