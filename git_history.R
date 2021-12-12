## 1 Simple dir command with order switch
#system("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat \> ./git_changes.csv")

library(tidyverse)
library(readtext)

shell("mkdir data")
shell("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --shortstat > data/git_changes.csv")
shell("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --date=local --pretty=format:\"%h; %an; %cd\" > data/git_by_date.csv")
shell("git -C C:/DEV/VivoHybris log --since=\"2019-10-11\" --no-merges --oneline --numstat > data/git_stats.txt")

df_git_by_date <- read.csv("data/git_by_date.csv", sep=";", header=FALSE)
df_git_by_date <- df_git_by_date %>% rename(
                                            "hash"=1,
                                            "name"=2,
                                            "date"=3
                                            )
text <- readtext("data/git_changes.csv")

text <- str_replace_all(text,"Esteira","Chocolate")

writeLines(text, "data/git_changes.csv")
df_git_changes <- read.csv("data/git_changes.csv", sep=";", header=FALSE)
