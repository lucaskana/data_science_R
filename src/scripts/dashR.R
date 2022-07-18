install.packages("dash")
install.packages("dashCoreComponents")

remotes::install_github("plotly/dashR", upgrade=TRUE)

library(dash)
library(dashCoreComponents)
library(tidyverse)
library(readtext)
library(tidyr)
library(naniar)
library(ggplot2)

repositorio <- "/home/lucas/Documentos/workspace/Repo"

system(paste("git -C",repositorio,"log --since=\"2019-10-11\" --no-merges --oneline --shortstat",">","src/data/git_changes.csv"))
system(paste("git -C",repositorio,"log --since=\"2019-10-11\" --no-merges --date=local --pretty=format:\"%h; %an; %cd\"",">","src/data/git_by_date.csv"))
system(paste("git -C",repositorio,"log --since=\"2019-10-11\" --no-merges --oneline --numstat",">","src/data/git_stats.txt"))
system(paste("git -C",repositorio,"log --since=\"2019-10-11\" --no-merges --name-status --oneline",">","src/data/git_name_only.txt"))

df_git_by_date <- read.csv("src/data/git_by_date.csv", sep=";", header=FALSE)
df_git_changes <- read.csv("src/data/git_changes.csv", sep=";", header=FALSE)
df_git_files <- read.csv("src/data/git_name_only.txt", sep=";", header=FALSE)

df_git_by_date <- df_git_by_date %>% rename(
  "hash"=1,
  "name"=2,
  "date"=3
)

ajustar_hash <- function(input) {
  if(!startsWith(input," ")) {
    output_data <- str_extract(input,'^[\\S]{9}')
    return(output_data)
  }
  else {
    return(NA)
  }   
}

?separate
df_git_files <- df_git_files %>% separate(V1, c('V1', 'files'),sep = "\t")

df_git_files <- df_git_files %>% mutate(hash=ajustar_hash(df_git_files$V1))
df_git_files <- df_git_files %>% fill(hash, .direction = 'down')
df_git_files <- df_git_files %>% filter(str_detect(V1, "^M|^A|^D"))

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

# Create a Dash app
app <- dash_app()

# Set the layout of the app
app %>% set_layout(
  h1('Hello Dash'),
  div("Dash: A web application framework for your data."),
  dccGraph(
    figure = list(
      data = list(
        list(
          x = list(1, 2, 3),
          y = list(4, 1, 2),
          type = 'bar',
          name = 'SF'
        ),
        list(
          x = list(1, 2, 3),
          y = list(2, 4, 5),
          type = 'bar',
          name = 'Montr\U{00E9}al'
        )
      ),
      layout = list(title = 'Dash Data Visualization')
    )
  )
)

# Run the app
app %>% run_app()
