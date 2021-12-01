# Load packages.
library(readxl)
library(janitor)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(ggalluvial)

# Load in PRT data.
raw_df <- read_excel("PRT_sankey.xlsx")

# Clean and make long.
clean_df <- raw_df %>% 
  clean_names() %>% 
  select(study, category, class) %>% 
  separate_rows(class, sep = ";") %>% 
  separate_rows(category, sep = ";")

# Frequencies and author label.
freq_df <- clean_df %>% 
  group_by(study, category, class) %>% 
  summarise(freq = n()) %>% 
  ungroup() %>% 
  complete(study, category, class, fill = list(freq = 0)) %>% 
  filter(freq != 0, category != "?") %>% 
  mutate(authors = str_remove_all(study, ".{7}$"))

# Check authors. Is it worth colouring them? Maybe not.
length(unique(freq_df$study))   # 32 studies
length(unique(freq_df$authors)) # 28 unique authors

# Check whether data is appropriate format.
is_alluvia_form(freq_df, axes = 1:3, silent = TRUE)

# Add padding for labels (terrible method but it works).
freq_df <- freq_df %>% 
  mutate(study_label    = paste0("             ", freq_df$study)   , sep = "",
         category_label = paste0("             ", freq_df$category), sep = "",
         class_label    = paste0("             ", freq_df$class)   , sep = "")

# Plot.
ggplot(freq_df, aes(y = freq, axis1 = study_label, axis2 = category_label, axis3 = class_label)) +
  geom_alluvium(aes(fill = class_label), width = 1/24, show.legend = FALSE) +
  geom_stratum(width = 1/20, fill = "snow") +
  geom_text(stat = "stratum", aes(label = after_stat(stratum)), size = 2.3, hjust = 0, colour = "snow") +
  scale_fill_viridis_d() +
  theme_void() +
  theme(plot.margin = margin(10,10,10,10),
        plot.background = element_rect(fill = "gray10")) 

# Save plot.
ggsave(filename = "alluvial.png", height = 20, width = 30)