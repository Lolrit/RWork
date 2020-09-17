library('keras')
library('tensorflow')
library("reticulate")

#use_condaenv("r-reticulate")

#read data
data <- read.csv(choose.files())
str(data)

#to matrix
data <-as.matrix(data)
dimnames(data) <- NULL

#normalizing data
data[,1:21] <- normalize(data[,1:21])
data[,22]<- as.numeric(data[,22]) -1
summary(data)

#data_part
set.seed(2048)
ind <- sample(2, nrow(data), replace = T, prob = c(0.75,0.25))
training <- data[ind==1, 1:21]
testing <- data[ind==2, 1:21]
trainingtarget <- data[ind==1,22]
testingtarget <- data[ind==2,22]

#encoding
trainlabels <-  to_categorical(trainingtarget)
testlabels <- to_categorical(testingtarget)
print(testlabels)

#creating sequential model
modela <- keras_model_sequential()
modela %>%
  layer_dense(units = 50, activation = 'relu', input_shape = c(21)) %>%
  layer_dense(units = 30, activation = 'relu') %>%
  layer_dense(units = 20, activation = 'relu') %>%
  layer_dense(units = 3, activation = 'softmax')
summary(modela)

#compilation
modela %>%
  compile(loss='categorical_crossentropy',  optimizer = 'adam' , metrics = 'accuracy')

#model_fitting
mod_his <- modela %>%
  fit(training,
      trainlabels,
      epoch = 250,
      batch_size = 48,
      validation_split = 0.2)
plot(mod_his)

#model_evaluation
model6 <- modela %>%
  evaluate(testing, testlabels)

#prediction&confusion matrix - testdata
prob <- modela %>%
  predict_proba(testing)

pred <- modela %>%
  predict_classes(testing)

#table
table6 <- table(predicted = pred, Actual = testingtarget)

cbind(prob , pred, testingtarget)

#finetuned 


table6
model6

