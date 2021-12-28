## 1 Simple dir command with order switch
#system("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat \> ./git_changes.csv")

install.packages("naniar")
install.packages("ggplot2")
#install.packages("pdftools")
#devtools::install_github("quanteda/readtext") 
# sudo apt-get install r-base-dev build-essential 
# sudo apt-get install build-essential libssl-dev libcurl4-openssl-dev libxml2-dev libcairo2-dev libgit2-dev
# sudo apt-get install libpoppler-cpp-dev  

library(tidyverse)
library(readtext)
library(tidyr)
library(naniar)
library(ggplot2)

#system("mkdir data")

system("git -C /media/lucas/SHARED/HY/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat > data/git_changes.csv")
system("git -C /media/lucas/SHARED/HY/VivoHybris log --since=\"2019-10-11\" --no-merges --date=local --pretty=format:\"%h; %an; %cd\" > data/git_by_date.csv")
system("git -C /media/lucas/SHARED/HY/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --numstat > data/git_stats.txt")

df_git_by_date <- read.csv("data/git_by_date.csv", sep=";", header=FALSE)
df_git_by_date <- df_git_by_date %>% rename(
                                            "hash"=1,
                                            "name"=2,
                                            "date"=3
                                            )

df_git_changes <- read.csv("data/git_changes.csv", sep=";", header=FALSE)

ajustar_hash <- function(input) {
  if(!startsWith(input," ")) {
    output_data <- str_extract(input,'^[\\S]{9}')
    return(output_data)
  }
  else {
    return(NA)
    }   
  }

df_git_changes <- df_git_changes %>% mutate(hash=ajustar_hash(df_git_changes$V1))
df_git_changes <- df_git_changes %>% rename("message" = 1)
df_git_changes <- df_git_changes %>% fill(hash, .direction = 'down')
df_git_changes <- df_git_changes %>% filter(startsWith(x = df_git_changes$message,prefix = " "))

df_git_changes <- df_git_changes %>% mutate(files_changed=str_extract(df_git_changes$message, "\\d+(?= file?)"))
df_git_changes <- df_git_changes %>% mutate(linsert=str_extract(df_git_changes$message, "\\d+(?= insertion?)"))
df_git_changes <- df_git_changes %>% mutate(ldelete=str_extract(df_git_changes$message, "\\d+(?= deletion?)"))

df_git_changes[is.na(df_git_changes)] = 0

df_git_changes$files_changed <- as.numeric(df_git_changes$files_changed)
df_git_changes$linsert <- as.numeric(df_git_changes$linsert)
df_git_changes$ldelete <- as.numeric(df_git_changes$ldelete)

df_git_changes <- df_git_changes %>% mutate(ldiff=linsert - ldelete)

df_git_changes <- filter(df_git_changes, ldelete < 2000)
df_git_changes <- filter(df_git_changes, linsert < 2000)

ggplot(data = df_git_changes) + 
  geom_point(mapping = aes(x = linsert, y = ldelete))

ggplot(data = df_git_changes) + 
  geom_bar(mapping = aes(x = linsert))

ggplot(data = df_git_changes) + 
  geom_bar(mapping = aes(x = ldelete))

ggplot(data = df_git_changes) + 
  geom_bar(mapping = aes(x = files_changed))

ggplot(data = df_git_changes) + 
  geom_bar(mapping = aes(x = ldiff))

ggplot(df_git_changes, aes(y=linsert)) + 
  geom_boxplot()

boxplot(select(df_git_changes,linsert,ldelete,files_changed,ldiff))

ggplot(data=df_git_changes, aes(x=linsert, y=ldelete)) +
  geom_line(color="red")+
  geom_point()

ggplot(df_git_changes, aes(x=linsert, y=ldiff)) + geom_point()

ggplot(df_git_changes, aes(x=ldelete, y=ldiff)) + geom_point()

#########################################################################################################################

#str_extract(df_git_changes[1,1], "\\d+(?= insertion?)")
#str_extract(df_git_changes[9,1], "\\d+(?= deletion?)")

ajustar_hash(df_git_changes[2,1])
df_git_changes %>% mutate(hash=ajustar_hash(df_git_changes$V1))

na_strings <- c("character(0)", "N A", "N / A", "N/A", "N/ A", "Not Available", "NOt available")

glimpse(df_git_changes)

#hashs <- str_extract_all(df_git_changes$V1,'^[\\S]{9}')
#text <- readtext("data/git_changes.csv")
#text <- str_replace_all(text,"Esteira","Chocolate")
#writeLines(text, "data/git_changes.csv")

df_git_changes <- df_git_changes %>% replace_with_na(replace = list(hash = "character(0)"))


df_git_changes %>%
  replace_with_na_all(condition = ~.x %in% na_strings)

common_na_strings

df_git_changes[df_git_changes == "character(0)"] <- "999"
df_git_changes <- df_git_changes %>% 
  replace_with_na_at(.var = c("character(0)"),
                     condition = ~.hash == "character(0)")

df_git_changes <- df_git_changes %>%
  replace_with_na_if(.predicate = is.character,
                     condition = ~.x %in% ("character(0)"))

na_strings <- c("character(0)")
df_3 <- df %>% replace_with_na_all(condition = ~.x %in% na_strings)

df_git_changes %>% replace_with_na_all(condition = ~.x == "character(0)")

#base_select_4 <- select(df_git_changes, starts_with("4")) # para algum prefixo comum
#df_git_changes[is.na(df_git_changes)] <- '.'
#df_git_changes[is.na(df_git_changes)]
#df_git_changes <- mutate(df_git_changes, 
#                         hash = replace(hash, hash=="character(0)", NA))

#df_git_changes %>% replace_with_na_all(condition = ~.hash == "character(0)")
#df_git_changes %>% replace_with_na_all(condition = ~.hash == "character(0)")

#df <- data.frame(Month = 1:12, Year = c(2000, rep(NA, 11)))
#df %>% fill(Year)

replace_na(df_git_changes, value=".")

df_git_changes %>% fill(hash, .direction = 'down')

is.na(df_git_changes[1,2])

df_git_changes_2 <- df_git_changes %>% fill(hash, .direction = 'up')

df_git_changes %>% replace_na("unknown")

df_git_changes <- df_git_changes %>% 
  mutate(hash=case_when(
    is.na(df_git_changes$hash) ~lag(hash, n = 1L),
    TRUE ~ hash
  ))

df_git_changes_insert_delete <- df_git_changes %>% filter(startsWith(df_git_changes$V1," "))
df_git_changes_insert_delete <- df_git_changes_insert_delete %>% rename(data=1)

separate(df_git_changes_insert_delete,col = data, sep = ",",into=c('fchanged', 'linserted','lremoved'))

df_git_changes_insert_delete<- df_git_changes_insert_delete %>% 
  mutate(insertion=str_extract_all(df_git_changes_insert_delete$data, "[\\d	]{1,} insertion", simplify = FALSE))
df_git_changes_insert_delete<- df_git_changes_insert_delete %>% 
  mutate(fchanged=str_extract_all(df_git_changes_insert_delete$data, "[\\d	]{1,} file", simplify = FALSE))
df_git_changes_insert_delete<- df_git_changes_insert_delete %>% 
  mutate(deletion=str_extract_all(df_git_changes_insert_delete$data, "[\\d	]{1,} deletion", simplify = FALSE))

df_git_changes_insert_delete[df_git_changes_insert_delete=="character(0)"] <- 0

df_git_changes_insert_delete['insertion'] <- gsub("[^0-9]+","",df_git_changes_insert_delete$insertion)
df_git_changes_insert_delete['fchanged'] <- gsub("[^0-9]+","",df_git_changes_insert_delete$fchanged)
df_git_changes_insert_delete['deletion'] <- gsub("[^0-9]+","",df_git_changes_insert_delete$deletion)


ggplot(df_git_changes_insert_delete) + 
  geom_bar(aes(x = insertion)) + 
  labs(x = "Insert",
       y = "Contagem") + 
  theme_light()

