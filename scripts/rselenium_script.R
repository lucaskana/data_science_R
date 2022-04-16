##Instalação
install.packages("RSelenium")

##Carregar o pacote da biblioteca
library("RSelenium")
library("rvest")
library("tidyverse")
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4445L,
  browserName = "firefox"
)

df_ufo <- read.csv("complete.csv")
df_nuclear <- read.csv("energy-pop-exposure-nuclear-plants-locations_plants.csv")

unique(df_ufo$country)

sf_nuclear <- st_as_sf(x = df_nuclear, 
                   coords = c("Longitude", "Latitude"), 
                   crs = 4326)

ggplot(df_ufo, aes(x=country)) + 
  geom_bar(stat = "count")

df_ufo <- df_ufo[!is.na(df_ufo['latitude']),]

df_ufo <- transform(df_ufo,
                    latitude = as.numeric(latitude))
str(df_ufo)

df_ufo <- filter(df_ufo, country == 'us')

sf_ufo <- st_as_sf(x = df_ufo, 
                         coords = c("longitude", "latitude"), 
                         crs = 4326)

map_ufo <- tm_shape(shp = sf_ufo) + 
  tm_dots(col = "deepskyblue4", 
          border.col = "black", 
          size = 0.2, 
          alpha = 0.8)
map_nuclear <- map_ufo + tm_shape(shp = sf_nuclear) + 
  tm_dots(col = "red", 
          border.col = "black", 
          size = 0.2, 
          alpha = 0.8)
map_nuclear
  
rD <- rsDriver(browser="firefox", port=4445L, verbose=F)
remDr <- rD[["client"]]

remDr$open()
remDr$navigate("https://www.google.com.br/maps/place/Santos+-+Imigrantes")
remDr$navigate("https://www.kinimoveis.com.br/imoveis/a-venda/apartamento/vila-mariana")
url_kini <- "https://www.kinimoveis.com.br/imoveis/a-venda/apartamento/sao-paulo/praca-da-arvore+saude+nova-saude+bosque-da-saude+chacara-inglesa+jabaquara?preco-de-venda=+700000&quartos=3+&area=70~"
remDr$navigate(url_kini)
webElem <- remDr$findElement(using = "xpath", "//div[@class='card-img-top b-lazy photo-0  page-1 b-error']")

webElem <- remDr$findElement(using = "class", "card-img-top b-lazy photo-0  page-1 b-error")
webElem <- remDr$findElement(using = "xpath", "//div[@class = 'card-img-top b-lazy photo-0  page-1 b-error']")

remDr$maxWindowSize()
remDr$screenshot(display = TRUE)
remDr$getCurrentUrl()

remDr$navigate("http://www.google.com/ncr")
remDr$navigate("http://www.bbc.co.uk")
remDr$getCurrentUrl()

remDr$goForward()
remDr$getCurrentUrl()

remDr$navigate("http://www.google.com/ncr")
webElem <- remDr$findElement(using = "name", value = "q")
webElem$getElementAttribute("name")

remDr$navigate("https://CRAN.r-project.org/")
XML::htmlParse(remDr$getPageSource()[[1]])


remDr$close()
rD$server$stop()
