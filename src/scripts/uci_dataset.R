library(tidyverse)
library(readtext)
library(tidyr)
library(naniar)
library(ggplot2)

df_iris <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data")
names(df_iris) <- c('sepallength','sepalwidth','petallength','petalwidth','class' )

str(df_iris)

pairs(df_iris[,1:4])

unzip("Vegetacao_5000mil.zip", exdir="vegetacao")
