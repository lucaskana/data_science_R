##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
pacotes <- c("httr","rvest","jsonlite")

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
#                  IBGE                                                          #
##################################################################################

library("rvest")
library("httr")
library("jsonlite")
library("data.table")

#1 - Listagem de indicadores - mostra na página web
url = "https://servicodados.ibge.gov.br/api/v1/paises/indicadores/77823"
page_data <- GET(url)
result <- fromJSON(url)

url = "https://servicodados.ibge.gov.br/api/v3/agregados"
result <- fromJSON(url)

result[1,1]

class(result[1,3])

data <- result[1,3]

class(data[[1]][1,])

length(data[[1]][,1])

length(result[1,3])

rep(result[1,1],)

# Extract the 2nd column from `MyList` with the selection operator `[` with `lapply()`
lapply(MyList,"[", , 2)

# Extract the 1st row from `MyList`
lapply(MyList,"[", 1, )