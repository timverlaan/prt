library(ggsankey)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readxl)
library(networkD3)

PRT_sankey <- read_excel("PRT/PRT_sankey.xlsx")

df <- PRT_sankey[, c(3, 2, 4,5)]

links <-
  df %>%
  mutate(row = row_number()) %>%  # add a row id
  pivot_longer(-row, names_to = "column", values_to = "source") %>%  # gather all columns
  mutate(column = match(column, names(df))) %>%  # convert col names to col ids
  group_by(row) %>%
  mutate(target = lead(source, order_by = column)) %>%  # get target from following node in row
  ungroup() %>% 
  filter(!is.na(target))  # remove links from last column in original data

links <-
  links %>%
  mutate(source = paste0(source, '_', column)) %>%
  mutate(target = paste0(target, '_', column + 1)) %>%
  select(source, target)

nodes <- data.frame(name = unique(c(links$source, links$target)))
nodes$label <- sub('_[0-9]*$', '', nodes$name) # remove column id from node label

links$source_id <- match(links$source, nodes$name) - 1
links$target_id <- match(links$target, nodes$name) - 1
links$value <- 1

sankeyNetwork(Links = links, Nodes = nodes, Source = 'source_id',
              Target = 'target_id', Value = 'value', NodeID = 'label')
