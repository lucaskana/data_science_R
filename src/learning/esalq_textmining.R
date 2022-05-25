##################################################################################
#                  INSTALAÇÃO E CARREGAMENTO DE PACOTES NECESSÁRIOS             #
##################################################################################
#Pacotes utilizados
pacotes <- c("tidytext","ggplot2","dplyr","tibble","gutenbergr","wordcloud","stringr","SnowballC","widyr","janeaustenr")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for(i in 1:length(instalador)) {
    install.packages(instalador, dependencies = T)
    break()}
  sapply(pacotes, require, character = T) 
} else {
  sapply(pacotes, require, character = T) 
}

##################################################################################
# Pacotes                                                                        #
##################################################################################

library("dplyr")
library("tidytext")
library("ggplot2")
library("tibble")

text <- c("From my infancy I was noted for the docility and humanity of my disposition.",
          "My tenderness of heart was even so conspicuous as to make me the jest of my companions.",
          "There is something in the unselfish and self-sacrificing love of a brute, which goes directly to the heart of him who has had frequent occasion to test the paltry friendship and gossamer fidelity of mere Man.")

text

#Uso do formato tibble e explicacao
text_df <- tibble(line = 1:3, text = text)
class(text_df)
#Explicao de token
#Abre funcao e explica unnest_tokens
#?unnest_tokens
df <-  text_df %>% unnest_tokens(word, text)

df_sem_stop_words <- df %>% anti_join(stop_words)
#Busca palavras mais comuns

conta <- df_sem_stop_words %>%  count(word, sort = TRUE) 

#Para facilitar a visualização

df_sem_stop_words %>%
  count(word, sort = TRUE) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() 


#install.packages("gutenbergr")
library("gutenbergr")
library("dplyr")
library("tidytext")
library("wordcloud")
library("stringr")
library("SnowballC")

textos <- gutenberg_metadata

#Vamos usar perter pan e Moby Dick
livros <- gutenberg_download(c(15,16))

#Vamos retirar números - pode ser qualquer coisa
nums <- livros %>% filter(str_detect(text, "^[0-9]")) %>% select(text) 

livros <- livros %>%  anti_join(nums, by = "text")

#Vamos nos livrar das stop words e obter os tokens
livros <- livros %>%  unnest_tokens(word, text) %>%  anti_join(stop_words)

#Contar as palavras mais comuns por obra

#Moby Dick
moby <- livros %>% filter(gutenberg_id == 15) %>% count(word, sort = TRUE)

# define a paleta de cores
pal <- brewer.pal(8,"Dark2")

# word cloud
moby %>% with(wordcloud(word, n, random.order = FALSE, max.words = 50, colors=pal))