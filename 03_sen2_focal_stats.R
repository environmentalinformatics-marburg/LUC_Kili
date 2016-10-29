# Compute artifical images for merged sentinel images

scene <- 802# oder 802
filepath_base <- "/media/dogbert/XChange/Masterarbeit/LUC_Kili/"



filepath_model <- paste0(filepath_base,"modeldata/")
filepath_raster <- paste0(filepath_base,"raster/scene_",scene,"/")
filepath_focal <- paste0(filepath_raster, "original_data")
filepath_addBands <- paste0(filepath_raster, "additional_bands/")
path_temp <- paste0(filepath_base,"tmp_dir")

# Libraries --------------------------------------------------------------------
library(mapview)
library(raster)


# Additional settings ----------------------------------------------------------
rasterOptions(tmpdir = path_temp)


# Import data ------------------------------------------------------------------
# list available files
fls <- list.files(filepath_focal, full.names = TRUE,
                  recursive = FALSE, pattern=  ".img")

# matrix of weights
w <- matrix(c(1, 1, 1,
              1, 1, 1,
              1, 1, 1), nrow = 3, ncol = 3)

# calculate focal mean and standard deviation
lst_fcl <- lapply(fls, function(i) {
  i <- fls[2]
  
  # import image
  rst <- raster(i)
  
  # calculate focal mean and standard deviation
  fls_mn <- paste0(filepath_addBands, "PCA",scene,"_focal_mean.img")
  fls_sd <- paste0(filepath_addBands, "PCA",scene,"_focal_sd.img")
  
  focal(rst, w = w, fun = mean, na.rm = TRUE, pad = TRUE,
        filename = fls_mn, format = "HFA", overwrite = TRUE)
  
  focal(rst, w = w, fun = sd, na.rm = TRUE, pad = TRUE,
        filename = fls_sd, format = "HFA", overwrite = TRUE)
  
})
