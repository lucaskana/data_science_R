##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
pacotes <- c("devtools","ggplot2","dplyr")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

##################################################################################
#                  Pacotes                                                      #
##################################################################################
library("devtools")

#Mostrar pacote no GITHUB
#https://github.com/TimoMatzen/RBM

install_github("TimoMatzen/RBM")
library("RBM")

### Teste 1 - Reconstruir Imagens

#### 2 - Visualiza imagens

data(MNIST)
image(matrix(MNIST$trainX[2, ], nrow = 28))

MNIST$trainY[2]

#### 3 - Treina modelo
set.seed(0)
train <- MNIST$trainX

modelRBM <- RBM(x = train, n.iter = 1000, n.hidden = 100, size.minibatch = 10, plot = TRUE)

#### 4 - Reconstroi a imagem

set.seed(0)
test <- MNIST$testX
testY <- MNIST$testY

test[100,]
testY[5]

ReconstructRBM(test = test[5, ], model = modelRBM)

### 5 - DBN

library(devtools)
library(RBM)

set.seed(0)

train <- MNIST$trainX
test <- MNIST$testX

modStack <- StackRBM(x = train, layers = c(100, 100, 100), n.iter = 1000, size.minibatch = 10)

ReconstructRBM(test = test[5, ], model = modStack, layers = 3)


### Teste 2 - Classificar Imagens - uso da atriz de confusão

#### 1 - Pacotes

#### 2 - Visualiza imagens
data(MNIST)
image(matrix(MNIST$trainX[102, ], nrow = 28))

#### 3 - Treina modelo

set.seed(0)
train <- MNIST$trainX
TrainY <- MNIST$trainY

modelClassRBM <- RBM(x = train, y = TrainY, n.iter = 1000, n.hidden = 100, size.minibatch = 10)

#### 5 - Acha matriz de confusão

set.seed(0)

test <- MNIST$testX
TestY <- MNIST$testY

p <- PredictRBM(test = test, labels = TestY, model = modelClassRBM)

p


### Exercício 1

library(dplyr)
library(RBM)

set.seed(0)

data(Fashion)


#'The labels are as follows: 
#'0: T-shirt/tops 
#'1: Trouser 
#'2: Pullover 
#'3: Dress 
#'4: Coat 
#'5: Sandal 
#'6: Shirt 
#'7: Sneaker 
#'8: Bag 
#'9: Ankle Boot 

image(matrix(Fashion$trainX[,102], nrow = 28))

Fashion$trainY[102]
Fashion$trainY[102]

#Diminui o tamanho para melhorar processamento
Fashion$trainX <- Fashion$trainX[,1:2000]
Fashion$trainY <- Fashion$trainY[1:2000]
Fashion$testX <- Fashion$testX[,1:200]
Fashion$testY <- Fashion$testY[1:200]

train <- t(Fashion$trainX)

#RBM
modelRBM <- RBM(x = train, n.iter = 1000, n.hidden = 100, size.minibatch = 10, plot = TRUE)

test <- t(Fashion$testX)

ReconstructRBM(test = test[102,], model = modelRBM)