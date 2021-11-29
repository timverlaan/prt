library(ggsankey)
library(dplyr)
library(ggplot2)
library(readxl)

df1 <- read_excel("PRT/PRT_sankey.xlsx")

df1 <- df1[, c(2, 3, 4,5)]

df_long <- df1 %>%
  make_long(Dataset,Sample,Category,Component) 

# ggplot(df_long, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = factor(node), label = node)) +
#   geom_sankey(flow.alpha = .6,
#               node.color = "gray30") +
#   geom_sankey_label(size = 0.2, color = "white", fill = "gray40") +
#   scale_fill_viridis_d() +
#   theme_sankey(base_size = 18) +
#   labs(x = NULL) +
#   theme(legend.position = "none",
#         plot.title = element_text(hjust = .5)) +
#   ggtitle("Literature on Police Response Time")

ggplot(df_long, aes(x = x, next_x = next_x, node = node, next_node = next_node, fill = factor(node), label = node)) +
  geom_alluvial(flow.alpha = .6) +
  geom_alluvial_text(size = 3, color = "white") +
  scale_fill_viridis_d(option = "A", alpha = .8) +
  theme_alluvial(base_size = 18) +
  labs(x = NULL) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = .5)) +
  ggtitle("Literature on Police Response Time")

