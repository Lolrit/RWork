library(EBImage)
library(keras) 

#reading Images 

setwd("C:/Users/Administrator/Documents/RImageDatabase")
pics <- c('c01.jpg','c02.jpg','c03.jpg','c04.jpg','c05.jpg','c06.jpg','c07.jpg','c08.jpg','c09.jpg','c10.jpg','c11.jpg','c12.jpg',
            'p01.jpg','p02.jpg','p03.jpg','p04.jpg','p05.jpg','p06.jpg','p07.jpg','p08.jpg','p09.jpg','p10.jpg','p11.jpg','p12.jpg',
            't01.jpg','t02.jpg','t03.jpg','t04.jpg','t05.jpg','t06.jpg','t07.jpg','t08.jpg','t09.jpg','t10.jpg','t11.jpg','t12.jpg',
            's01.jpg','s02.jpg','s03.jpg','s04.jpg','s05.jpg','s06.jpg','s07.jpg','s08.jpg','s09.jpg','s10.jpg','s11.jpg','s12.jpg')
mypic <- list()
for (i in 1:48){
  mypic[[i]] <- readImage(pics[i])
}

print(mypic[[1]])          
display(mypic[[21]])
summary(mypic[[1]])
hist(mypic[[1]])

str(mypic)

#resize

for(i in 1:48){
  mypic[[i]] <- resize(mypic[[i]], 28, 28)
}

#reshaping

for(i in 1:48){
  mypic[[i]] <- array_reshape(mypic[[i]], c(28,28,3))
}

#row bind

trainx <-  NULL
for(i in 1:10){
  trainx <- rbind(trainx, mypic[[i]])
}

str(trainx) 

for(i in 13:22){
  trainx <- rbind(trainx, mypic[[i]])
}

str(trainx) 

for(i in 25:34){
  trainx <- rbind(trainx, mypic[[i]])
}

str(trainx) 

for(i in 37:46){
  trainx <- rbind(trainx, mypic[[i]])
}

str(trainx) 

testx <- rbind(mypic[[12]],mypic[[24]],mypic[[36]],mypic[[11]],mypic[[23]],mypic[[35]],mypic[[47]],mypic[[48]])
trainy <- c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3)
testy <- c(0,0,1,1,2,2,3,3)

#one-hot encoding

trainLabels <- to_categorical(trainy)
testLabels <-  to_categorical(testy)

#model-creation

model <- keras_model_sequential()
model %>%
  layer_dense(units = 512, activation = 'relu',  input_shape = c(2352)) %>%
  layer_dense(units = 256, activation = 'relu') %>%
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dense(units = 64, activation = 'relu') %>%
  layer_dense(units = 32, activation = 'relu') %>%
  layer_dense(units = 16, activation = 'relu') %>%
  layer_dense(units = 8, activation = 'relu') %>%
  layer_dense(units = 4, activation = 'softmax')
summary(model)

#compilation
model %>%
  compile(loss = 'binary_crossentropy',
          optimizer = optimizer_rmsprop(),
          metrics = c('accuracy'))

#fit model

history <- model %>%
  fit(trainx, 
      trainLabels,
      epochs = 256,
      batch_size = 64,
      validation_split = 0.15)
 plot(history) 
 
#model evaluation
 
model %>% evaluate(trainx,trainLabels)
pred <- model %>% predict_classes(trainx)
table(Predicted = pred, Actual = trainy)

prob <- model %>% predict_proba(trainx) 
cbind(prob, Predicted = pred, Actual= trainy)

#Eval and Predict

model %>% evaluate(testx, testLabels)
pred1 <- model %>% predict_classes(testx)
pred1

prob1 <- model %>% predict_proba(testx) 
table(Predicted = pred1, Actual = testy)
cbind(prob1, Predicted = pred1, Actual= trainy)
