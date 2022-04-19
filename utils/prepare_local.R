

listfiles <- list.files(path="./ESALQ",pattern = "*.zip",full.names=TRUE)

## Unzip Files
for(item in listfiles){
  #print(c('Unziping files ->',item))
  destdir <- sub('\\.zip$', '', item)
  destdir <- sub('./ESALQ/', '', destdir)
  unzip(item, exdir = paste("./scripts_ESALQ",destdir, sep="/"))
  #print(paste("../script",destdir, sep="/"))
}
