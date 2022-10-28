library(dplyr)

#### Load peptideGroups ####
pepg_oops <- read.delim("dev/data-raw/STM2457_48h_oops_PeptideGroups.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":"))
pepg_total <- read.delim("dev/data-raw/STM2457_48h_total_PeptideGroups.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":"))

#### give

meta <- data.frame(
  file = rep(paste0("F", 1:4), each = 2),
  label = rep(c("Light", "Heavy"), 4),
  drug = rep(c("STM2120", "STM2457", "STM2457", "STM2120"), 2)
)

library(QFeatures)



qf <- QFeatures::readQFeatures(
  table = pepg_oops,
  ecol = grepl("Abundances\\.Grouped", colnames(pepg_oops)),
  fnames = "id",
  name = 'oops'
)

qf[[1]] %>% assay() -> aaa
qf[[1]] %>% rowData() -> bbb
qf[[1]] %>% colData()

qf2 <- readQFeatures(
  table = pepg_total,
  ecol = grepl("Abundances\\.Grouped", colnames(pepg_total)),
  fnames = "id",
  name = 'total'
)

qf2[[1]] %>% colData()

qf3 <- QFeatures(list(qf ,qf2))

