library("stringr")

listfiles <- list.files(path="./ESALQ",pattern = "*.zip",full.names=TRUE)

## Unzip Files
for(item in listfiles){
  #print(c('Unziping files ->',item))
  destdir <- sub('\\.zip$', '', item)
  destdir <- sub('./ESALQ/', '', destdir)
  unzip(item, exdir = paste("./scripts_ESALQ",destdir, sep="/"))
  #print(paste("../script",destdir, sep="/"))
}

pattern <-c('\\87','\\xc6','\\xa','\\x82')

listfiles <- list.files(path="./scripts_ESALQ",recursive = TRUE,full.names=TRUE)
for(f in listfiles){
  print(f)
}

file.rename(listfiles,str_replace_all(listfiles,"\\\\", ""))
