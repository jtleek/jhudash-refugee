library(rvest)
library(httr)
url1 = "https://en.wikipedia.org/wiki/List_of_countries_by_immigrant_population"


immigrant = url1 %>% html %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>%
  html_table()

immigrant = immigrant[[1]]

head(immigrant)