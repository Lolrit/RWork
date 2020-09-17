library(reticulate)
library(keras)
library(mlbench)
library(neuralnet)
library(magrittr)
library(dplyr)
library(tensorflow)


# use_condaenv("r-reticulate")


#taking data

data("BostonHousing")
data <-  BostonHousing
str(data)

data %<>% mutate_if(is.factor,as.numeric)
str(data)

#NeuralNetModel

n <- neuralnet(medv ~ crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+b+lstat,
               data = data,
               hidden = c(10,5),
               linear.output = F,
               lifesign = 'full',
               rep=1) 
plot(n,
     col.hidden = 'darkgreen',
     col.hidden.synapse = 'darkgreen',
     show.weights = F,
     information = F,
     fill = 'lightblue')

data<-as.matrix(data)
dimnames(data) <- NULL

#Partition

set.seed(1234)
ind <- sample(2, nrow(data), replace = T, prob = c(0.70,0.30))
train <- data[ind==1,1:13]
test <- data[ind==2,1:13]
traintarget <- data[ind==1,14]
testtarget <- data[ind==2,14]

#Normalisation
#Normalised val = (Value - mean)/standard deviation

m <- colMeans(train)
s <- apply(train, 2, sd)

train <- scale(train, center = m, scale = s)
test <- scale(test, center = m, scale = s)

#Create model

model <- keras_model_sequential()
model %>%
  layer_dense(units = 50, activation = 'relu', input_shape= c(13)) %>%
  layer_dense(units = 40, activation = 'relu') %>%
  layer_dense(units = 1)

#model_compile

model %>% compile(loss = 'mse',
                  optimizer = 'rmsprop',
                  metrics = 'mae')

#fit model

mymodel <- model %>%
  fit(train,
      traintarget,
      epochs = 150,
      batch_size = 32,
      validation_split = 0.2)

#Evaluate 

model %>% evaluate(test,  testtarget)
pred <- model %>% predict(test)
mean((testtarget-pred)^2)
plot(testtarget,pred)
