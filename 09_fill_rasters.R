library(raster)


class_204 <- raster("/media/dogbert/XChange/Masterarbeit/LUC_Kili/prediction/classification_204.tif")
class_802 <- raster("/media/dogbert/XChange/Masterarbeit/LUC_Kili/prediction/classification_802.tif")

lookup_mat <- data.frame(is = unique(values(class_204)),
                         becomes = unique(values(class_204)))

lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==57, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==98, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==99, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==60, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes>0, 1)


c204_rec <- reclassify(class_204, rcl = lookup_mat)
c802_rec <- reclassify(class_802, rcl = lookup_mat)
plot(c204_rec)

class_204_cropped <- c204_rec*class_204
class_802_cropped <- c802_rec*class_802


lookup_mat2 <- data.frame(is = c(NA,1), becomes= c(1,NA))

c204_rec_turn <- reclassify(c204_rec, rcl = lookup_mat2)
c802_rec_turn <- reclassify(c802_rec, rcl = lookup_mat2)


class_204_fill <- c204_rec_turn*class_802
class_802_fill <- c802_rec_turn*class_204

class_204_filled <- merge(class_204_cropped,class_204_fill)
class_802_filled <- merge(class_802_cropped,class_802_fill)

lookup_mat <- data.frame(is = unique(values(class_204_filled)),
                         becomes = unique(values(class_204_filled)))

lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==57, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==98, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==99, NA)
lookup_mat$becomes <- replace(lookup_mat$becomes, lookup_mat$becomes==60, NA)
class_204_filled_rec <- reclassify(class_204_filled, rcl = lookup_mat)
plot(class_204_filled_rec)
class_802_filled_rec <- reclassify(class_802_fill, rcl = lookup_mat)

sum(is.na(values(class_204_filled_rec)))
sum(is.na(values(class_802_fill_rec)))

writeRaster(class_204_filled_rec, filename = "/media/dogbert/XChange/Masterarbeit/LUC_Kili/results/filled_scenes/classification_204_filled.tif")
writeRaster(class_802_fill_rec, filename = "/media/dogbert/XChange/Masterarbeit/LUC_Kili/results/filled_scenes/classification_802_filled.tif")


