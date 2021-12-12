## 1 Simple dir command with order switch
#system("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat \> ./git_changes.csv")

library(tidyverse)
library(readtext)

#shell("mkdir data")
shell("git -C D:/HY/workspace/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat > data/git_changes.csv")
shell("git -C D:/HY/workspace/VivoHybris log --since=\"2019-10-11\" --no-merges --date=local --pretty=format:\"%h; %an; %cd\" > data/git_by_date.csv")
shell("git -C D:/HY/workspace/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --numstat > data/git_stats.txt")

df_git_by_date <- read.csv("data/git_by_date.csv", sep=";", header=FALSE)
df_git_by_date <- df_git_by_date %>% rename(
                                            "hash"=1,
                                            "name"=2,
                                            "date"=3
                                            )
#text <- readtext("data/git_changes.csv")
  
#text <- str_replace_all(text,"Esteira","Chocolate")

#writeLines(text, "data/git_changes.csv")
df_git_changes <- read.csv("data/git_changes.csv", sep=";", header=FALSE)

#hashs <- str_extract_all(df_git_changes$V1,'^[\\S]{9}')

df_git_changes <- df_git_changes %>% mutate(hash=str_extract_all(df_git_changes$V1,'^[\\S]{9}'))
df_git_changes[df_git_changes=="character(0)"] <- NA

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

