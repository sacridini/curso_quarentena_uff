library(raster)

r <- raster::stack("Documents/curso_rf/mosaic.tif") # Carrega o raster de entrada (1 imagem - 12 bandas)
v <- raster::shapefile("Documents/curso_rf/amostras_2.shp") # Carrega o shapefile
v_df <- as.data.frame(v) # Transforma o shapefile em dataframe

for (i in 1:dim(r)[3]) {
  v_df[, paste0("B", i)] <- raster::extract(r[[i]], v)
}
