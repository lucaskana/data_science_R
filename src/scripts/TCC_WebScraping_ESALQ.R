##Instalação
install.packages("RSelenium")
install.packages("rvest")
install.packages("tidyverse")
install.packages("netstat")
install.packages("writexl")

library("httr")
library("rvest")
library("RSelenium")
library(netstat)
library("writexl")
library(stringr)
library(dplyr)


rD <- rsDriver(browser="chrome", chromever="103.0.5060.53", verbose=T)
remDr <- rD[["client"]]
remDr$navigate("https://defesas.linka.la/#presentation-anchor")
pesquisar <- remDr$findElement("class", "rbt")
#input <- pesquisar$findChildElement(using = 'tag name', value = 'input')
## Criterio de busca


option <- remDr$findElement(using = 'xpath',value = "//*[text() = '01/07/2022']")
option$clickElement()

option <- remDr$findElement(using = 'xpath',value = "//*[text() = 'Todos os horários']")
option$clickElement()

option <- remDr$findElement(using = 'xpath', "//*/option[@value = 'Data Science e Analytics']")
option$clickElement()

## Filtrar e buscar
buttonsearch <- remDr$findElement(using = 'xpath',value = "//*[text() = 'Filtrar']")
buttonsearch$clickElement()

## Result
result <- remDr$findElement("id", "presentation-anchor")


#tcclist <- resultlist[[2]]$findChildElements(using = 'xpath', value = "./div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")

tcclist <-result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]/div")


## Loop Over temas
temas <- c()

for (i in 1:length(tcclist)) {
  temas <-  append(temas,tcclist[[i]]$findChildElement(using = 'tag name', value = 'div')$getElementAttribute('innerHTML'))
}

## Loop Over agenda
agenda <- c()
sectionTitle <- result$findChildElements(using = 'xpath', value = ".//section")
resultlist <- result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
for (i in 1:length(resultlist)) {
  subitems <- resultlist[[i]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
  print(length(subitems))
  temp <- list(rep(sectionTitle[[i]]$getElementText(),length(subitems)))
  agenda <- append(agenda,temp)
}

agenda <- unlist(agenda, recursive = TRUE, use.names = TRUE)

df <- data.frame(title=unlist(temas),agenda=unlist(agenda))
names(df) = c("Title","Agenda")

## Limpar caracteres
df$Agenda <- gsub("Defesas\nRecolher","",as.character(df$Agenda))
df$Agenda <- gsub("Defesas\nMostrar","",as.character(df$Agenda))

df[c('Dia', 'Horario')] <- str_split_fixed(df$Agenda, '\n', 2)
df$Horario <- gsub("\n","",as.character(df$Horario))
df$Dia <- as.Date(df$Dia, format = "%d/%m/%Y")
df <- df %>% relocate(Agenda, .after = last_col())
write_xlsx(df, paste(Sys.getenv("USERPROFILE"),"Desktop","tccesalq.xlsx", sep="\\", collapse=NULL))

str(df)
system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)

#########################
#
# SandBox
#
########################

#resultlist <- sectionTitle$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
#resultlist <- result$findChildElements(using = 'xpath', value = ".//section/div")
#resultlist[[1]]$getElementAttribute('innerHTML')
#resultlist[[1]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
#resultlist[[1]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")[[1]]$getElementAttribute('innerHTML')

#resultlist <- result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
#subitems <- resultlist[[3]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
#sectionTitle <- result$findChildElements(using = 'xpath', value = ".//section/div")
#sectionTitle[[1]]$getElementAttribute('innerHTML')
#sectionTitle[[1]]$getElementText()
#resultlist <- result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
#subitems <- resultlist[[3]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")

#list(rep(sectionTitle[[1]]$getElementText(),length(subitems)))
#length(subitems[[1]])

#agenda <- c()
#sectionTitle <- result$findChildElements(using = 'xpath', value = ".//section")
#resultlist <- result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
#for (i in 1:length(resultlist)) {
  #resultlist <- sectionTitle$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")
  #subitems <- resultlist[[i]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
  #print(length(subitems))
  #temp <- list(rep(sectionTitle[[i]]$getElementText(),length(subitems)))
  #agenda <- append(agenda,temp)
#}

#agenda <- unlist(agenda, recursive = TRUE, use.names = TRUE)

#student = data.frame(unlist(temas),unlist(agenda))
#subitems <- sectionTitle[[1]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
#resultlist <- result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'row mt-4')]")

#length(resultlist[[4]]$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]"))

#tcclist <-result$findChildElements(using = 'xpath', value = ".//div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]/div")
#tcclist[[2]]$findChildElement(using = 'tag name', value = 'div')$getElementAttribute('innerHTML')
#tcclist[[2]]$getElementAttribute('innerHTML')
#tcclist[[1]]$findChildElement(using = 'class name', value = 'col')$getElementText()

#tcclist[[1]]$getElementAttribute('innerHTML')

#Data <- as.data.frame(do.call(rbind, temas),col.names = c("temas"))  
#print(temas)

#dropcourse <- remDr$findElement("id", "courses")
#opts <- dropcourse$selectTag()
#opts$elements[[3]]
#opts$selected <- c(FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)

#tcclist[[1]]$findChildElement(using = 'class name', value = 'col')$getElementText()

#resultlist[[1]]$getElementAttribute('innerHTML')

#resultlist[[1]]$findChildElement(using = 'class name', value = 'col')$getElementText()

#subitems <- resultlist[[1]]$findElement(using = 'tag name', value = 'div')
#subitems$findChildElements(using = 'tag name', value = 'div')[[3]]$getElementText()

## Matar processo Selenium
#pesquisar$sendKeysToElement("NEUROD1")
#pesquisar$getElementAttribute('innerHTML')
#resultlist[[1]]$getElementAttribute('innerHTML')
#webElem <- dropcourse$findElement(using = 'css selector', value = "option:nth-child(5)")
#webElem$clickElement()
# check whether it is selected
#opts$selected
#opts$elements[[3]]$clickElement()
#opts$selected <- c(FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)
#result <- remDr$findElement("id", "presentation-anchor")
#resultlist <- result$findChildElement(using = 'tag name', value = 'section')
#resultdiv <- resultlist$findChildElements(using = 'tag name', value = 'div')
#resultdiv[[1]]$getElementAttribute('innerHTML')
#resultdiv[[3]]$getElementAttribute('innerHTML')
#search <- remDr$findElement("class", "d-flex")
#search$getElementAttribute('innerHTML')
#searchbutton <- pesquisar$findChildElement(using = 'tag name', value = 'button')
#rD <- rsDriver(verbose=TRUE,port=free_port(),browserName='chrome',check=TRUE)
#rD[["server"]]$stop()
#driver <- rsDriver(browser=c("chrome"),chromedriver='102.0.5005.115',port=4567L)
#driver <- rsDriver(browser=c("chrome"),port=4567L)
#drive$navigate("http://www.google.com/ncr")
#remote_driver$open()
#Abre o servidor
#remDr$open()
#wikipedia <- read_html("https://defesas.linka.la/#presentation-anchor")
#wikipedia %>% html_text()
