listfiles <- list.files(path="./ESALQ",pattern = "*.zip",full.names=TRUE)

## Unzip Files
for(item in listfiles){
  print(c('Unziping files ->',item))
  destdir <- sub('\\.zip$', '', item)
  unzip(item, exdir = destdir)
}
