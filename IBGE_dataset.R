# Instalação e Carregamento dos Pacotes Necessários para a Aula -----------

pacotes <- c("rgdal","raster","tmap","maptools","tidyverse","broom","knitr",
             "kableExtra","RColorBrewer")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

################################## SHAPEFILES ##################################

# 
url <- "https://geoftp.ibge.gov.br/recortes_para_fins_estatisticos/malha_de_aglomerados_subnormais/censo_2010/areas_de_divulgacao_da_amostra/shape/SetoresXAreaDivAGSN_shp.zip"
destfile <- "SetoresXAreaDivAGSN_shp.zip"
setores_sp <- "setores"
download.file(url, destfile)
unzip(destfile,exdir = setores_sp)
# 1. PARTE INTRODUTÓRIA

# Carregando um shapefile -------------------------------------------------
shp_sp <- readOGR(dsn = setores_sp, encoding="UTF-8", layer = "SetoresXAreaDivAGSN")

# Características básicas do objeto shp_sp
summary(shp_sp)


shp_sp@data %>% 
  kable() %>%
  kable_styling(bootstrap_options = "striped", 
                full_width = TRUE, 
                font_size = 12)

# Plotagem básica de um shapefile -----------------------------------------
plot(shp_sp)
