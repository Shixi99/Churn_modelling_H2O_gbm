library(h2o)
library(tidyverse)
h2o.init()

data <- h2o.importFile('C:/Users/dell/Downloads/Churn_Modelling.csv')

data["Gender"] <- as.numeric(data["Gender"])
data["Exited"] <- as.factor(data["Exited"])

predictors <- c("CreditScore","Gender","Age","Tenure","Balance","NumOfProducts","HasCrCard","IsActiveMember","EstimatedSalary")
response <- "Exited"

# splitting data
data <- h2o.splitFrame(data,ratios = c(0.7,0.15),seed=123)
train<-data[[1]]
validation<-data[[2]]
test<-data[[3]]

# train a gbm using the nfolds parameter:
data_gbm <- h2o.gbm(x = predictors, 
                    y = response, 
                    training_frame = train, 
                    validation_frame = validation,
                    seed = 1234)


data %>% glimpse()
perf <- h2o.performance(data_gbm, train)
train_auc<-h2o.auc(perf, xval = TRUE)

perf <- h2o.performance(data_gbm, test)
test_auc<-h2o.auc(perf, xval = TRUE)

tibble(train_auc, test_auc)

