library("stringr")
library(stringi)


listfiles <- list.files(path="./src/ESALQ",pattern = "*.zip",full.names=TRUE)

## Unzip Files
for(item in listfiles){
  #print(c('Unziping files ->',item))
  destdir <- sub('\\.zip$', '', item)
  destdir <- sub('./src/ESALQ/', '', destdir)
  unzip(item, exdir = paste("./src/scripts_ESALQ",destdir, sep="/"))
  #print(paste("../script",destdir, sep="/"))
}

listfiles <- list.files(path="./src/scripts_ESALQ",recursive = TRUE,full.names=TRUE)
for(f in listfiles){
  print(f)
}

file.rename(listfiles,str_replace_all(listfiles,"\\\\", ""))

#listfiles <- stri_encode(listfiles,"UTF-8")
#pattern <-c('\\87','\\xc6','\\xa','\\x82')
#?stri_encode
