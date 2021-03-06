library(networkD3)
library(data.table)
library(ggsankey)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readxl)

PRT_sankey <- read_excel("~/PRT/prt/PRT_sankey_v2.xlsx")

d <- PRT_sankey[, c(1,2,4,5, 6,7,8)]

setDT(d)

# make links
links <- rbind(d[, .(source = Dataset, target = Category) ],
               d[, .(source = Category, target = Class) ])
links[, rn := .I]
# adjust value, based on "split"
links <- links[, strsplit(source, split = ";", fixed = TRUE), by = .(source, target, rn)
][, .(source = V1, target, rn)
][, strsplit(target, split = ";", fixed = TRUE), by = .(source, target, rn) 
][, .(source, target = V1, rn)
][, .(source, target, value = 1/.N), by = rn]
# make nodes
nodes <- data.frame(name = unique(unlist(links[,.(source, target)])))
nodes$label <- nodes$name

# update link ids
links$source_id <- match(links$source, nodes$name) - 1
links$target_id <- match(links$target, nodes$name) - 1

# plot
sankeyNetwork(Links = links, Nodes = nodes, Source = 'source_id',
              Target = 'target_id', Value = 'value', NodeID = 'label',
              fontSize = 12, fontFamily = 'Verdana')

