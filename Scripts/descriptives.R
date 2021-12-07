library(networkD3)
library(data.table)
library(ggsankey)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readxl)

df <- read_excel("~/PRT/PRT_coding_v2.xlsx", sheet = "varss")


length(unique(df$`Function`))

count(df, vars = `Statistical group`)

count(df, vars = `Statistical group`)
count(df, vars = `Test type`)
count(df, vars = `Correlation_type`)


df_simple <- subset(df, Correlation_type=='simple')
df_multi <- subset(df, Correlation_type=='multiple')

count(df_simple, vars = `Statistical group`)
count(df_simple, vars = `Test type`)
count(df_multi, vars = `Statistical group`)
count(df_multi, vars = `Test type`)
