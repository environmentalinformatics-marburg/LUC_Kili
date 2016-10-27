# This script is for merging the sentinel bands from east and west together.

library(raster)

scene <- 204# oder 802
filepath_base <- "/media/benjamin/XChange/Masterarbeit/LUC_Kili/"
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")

fls_sen <- list.files(paste0(filepath_raster, "merged_sentinel_bands"), full.names = TRUE,
                      recursive = TRUE, pattern=".img$")

if (length(fls_sen) < 10){
  
  fls_west <-  list.files(paste0(filepath_raster, "original_data/S2A_USER_MTD_SAFL2A_PDMC_R092_20160204T075210_west_resampled"), full.names = TRUE,
                          recursive = TRUE, pattern=".img$")
  fls_east <- list.files(paste0(filepath_raster, "original_data/S2A_USER_MTD_SAFL2A_PDMC_R092_20160204T075210_East_resampled"), full.names = TRUE,
                         recursive = TRUE, pattern=".img$")
  
  for (i in seq(1,10)){
    rst_west <- raster(fls_west[i])
    rst_east <- raster(fls_east[i])
    
    merge(rst_west, rst_east, filename=paste0(filepath_raster,"merged_sentinel_bands/",
                                              names(rst_west) ), overwrite=TRUE)
  }
  
}