##Instalação
install.packages("RSelenium")
install.packages("rvest")
install.packages("tidyverse")
install.packages("netstat")

library("httr")
library("rvest")
library("RSelenium")
library(netstat)


rD <- rsDriver(browser="chrome", chromever="103.0.5060.53", verbose=T)
remDr <- rD[["client"]]
remDr$navigate("https://defesas.linka.la/#presentation-anchor")
pesquisar <- remDr$findElement("class", "rbt")
input <- pesquisar$findChildElement(using = 'tag name', value = 'input')
## Criterio de busca
input$sendKeysToElement(list("NEUROD2", key = "enter"))

option <- remDr$findElement(using = 'xpath',value = "//*[text() = '28/06/2022']")
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
resultlist <- result$findChildElements(using = 'xpath', value = "//div[contains(@class, 'mt-4')]")

#tcclist <- resultlist[[2]]$findChildElements(using = 'xpath', value = "./div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")

temas <- c()
# loop version 2
for (i in 1:length(resultlist)) {
  tcclist <- resultlist[[i]]$findChildElements(using = 'xpath', value = "./div[contains(@class, 'col-12 col-sm-6 col-lg-4 col-xl-3 mb-4 d-flex align-content-between')]")
  for (j in 1:length(tcclist)){
    temas <-  append(temas,tcclist[[j]]$findChildElement(using = 'class name', value = 'col')$getElementText())
  }
}

print(temas)

system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


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


resultlist[[1]]$getElementAttribute('innerHTML')


webElem <- dropcourse$findElement(using = 'css selector', value = "option:nth-child(5)")
webElem$clickElement()
# check whether it is selected

opts$selected
opts$elements[[3]]$clickElement()
opts$selected <- c(FALSE,FALSE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)



result <- remDr$findElement("id", "presentation-anchor")
resultlist <- result$findChildElement(using = 'tag name', value = 'section')
resultdiv <- resultlist$findChildElements(using = 'tag name', value = 'div')
resultdiv[[1]]$getElementAttribute('innerHTML')
resultdiv[[3]]$getElementAttribute('innerHTML')
search <- remDr$findElement("class", "d-flex")
search$getElementAttribute('innerHTML')
searchbutton <- pesquisar$findChildElement(using = 'tag name', value = 'button')

#rD <- rsDriver(verbose=TRUE,port=free_port(),browserName='chrome',check=TRUE)
#rD[["server"]]$stop()

#driver <- rsDriver(browser=c("chrome"),chromedriver='102.0.5005.115',port=4567L)
#driver <- rsDriver(browser=c("chrome"),port=4567L)
#drive$navigate("http://www.google.com/ncr")
#remote_driver$open()

#Abre o servidor
#remDr$open()

wikipedia <- read_html("https://defesas.linka.la/#presentation-anchor")
wikipedia %>% html_text()
