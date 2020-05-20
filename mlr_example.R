# install.packages("mlr", dependencies = TRUE)
# install.packages("mclust", dependencies = TRUE)
# install.packages("tidyverse", dependencies = TRUE)
# install.packages("randomForest", dependencies = TRUE)

library(mlr)
library(tidyverse)

# Load Data ---------------------------------------------------------------
data(diabetes, package = "mclust")
diabetesTib <- as_tibble(diabetes)
diabetesTib


# Plot Data ---------------------------------------------------------------
ggplot(diabetesTib, aes(glucose, insulin, col = class)) + geom_point()
ggplot(diabetesTib, aes(sspg, insulin, col = class)) + geom_point()
ggplot(diabetesTib, aes(sspg, glucose, col = class)) + geom_point()


# Define Task -------------------------------------------------------------
# Define Data - Target
diabetesTask <- makeClassifTask(data = diabetesTib, target = "class")


# Define a Learner --------------------------------------------------------
knn <- makeLearner("classif.knn", par.vals = list("k" = 2))
rf = makeLearner("classif.randomForest", predict.type = "prob", fix.factors.prediction = TRUE)

# Listas todos os algoritmos de classificação do MLR 
# listLearners()$class


# Training the Model ------------------------------------------------------
knnModel <- train(knn, diabetesTask)
rfModel <- train(rf, diabetesTask)

# Testing Performance (Cross-Validation) ----------------------------------
kFold <- makeResampleDesc("RepCV", folds = 10, reps = 50)
kFoldCV <- resample(learner = knn, task = diabetesTask, resampling = kFold)
rfFoldCV <- resample(learner = rf, task = diabetesTask, resampling = kFold)

calculateConfusionMatrix(kFoldCV$pred)

# Usando rasters
# new_data <- as.data.frame(as.matrix(r))
# pred_rf <- raster::predict(rfModel, newdata = new_data)
# pred = r # Cria um raster
# pred[] = pred_rf$data$response
# writeRaster(pred, "output_class_rf.tif")