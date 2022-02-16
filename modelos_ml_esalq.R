########################
# Instalação de pacotes
pacotes <- c(
  'tidyverse',  # Pacote básico de datawrangling
  'rpart',      # Biblioteca de árvores
  'rpart.plot', # Conjunto com Rpart, plota a parvore
  'gtools',     # funções auxiliares como quantcut,
  'Rmisc',      # carrega a função sumarySE para a descritiva
  'scales',     # importa paletas de cores
  'viridis',    # Escalas 'viridis' para o ggplot2
  'caret',       # Funções úteis para machine learning
  'AMR',
  'randomForest',
  'fastDummies',
  'rattle',
  'xgboost'
  
)

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

#########################
# • Tentar classificar atividade humana por acelerômetro e giroscópio de celular
# https://archive.ics.uci.edu/ml/datasets/human+activity+recognition+using+smartphones
# • Identificar doença cardíaca
# 'https://archive.ics.uci.edu/ml/datasets/Heart+Disease


#temp <- tempfile()
#download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip",temp)
#data <- read.csv(unz(temp, "UCI HAR Dataset\\train\\x_train.txt"))
#unlink(temp)

#1. 3 (age)
#2. 4 (sex)
#3. 9 (cp)
#4. 10 (trestbps)
#5. 12 (chol)
#6. 16 (fbs)
#7. 19 (restecg)
#8. 32 (thalach)
#9. 38 (exang)
#10. 40 (oldpeak)
#11. 41 (slope)
#12. 44 (ca)
#13. 51 (thal)
#14. 58 (num) (the predicted attribute)

##############################################
#
# Regression Tree
#
##############################################

col_disease_names <- c('age','sex','cp','trestbps','chol','fbs','restecg','thalach','exang','oldpeak','slope','ca','thal','num')

data <- read.delim('https://archive.ics.uci.edu/ml/machine-learning-databases/heart-disease/processed.hungarian.data'
                   ,col.names = col_disease_names
                   ,sep = ","
                   ,header = F)

# Construindo a árvore #
tree <- rpart(num~age+sex+cp+trestbps+chol+fbs+restecg+thalach+exang+oldpeak+slope+ca+thal, 
              data=data,
              control=rpart.control(maxdepth = 3, cp=0))

# Plotando a árvore
paleta = scales::viridis_pal(begin=.75, end=1)(20)
rpart.plot::rpart.plot(tree,
                       box.palette = paleta) # Paleta de cores


data['p'] = predict(tree, data)
data['r'] = data$num - data$p

##############################################
#
# Bootstrapping
#
##############################################

