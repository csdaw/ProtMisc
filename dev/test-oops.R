library(dplyr)

library(QFeatures)

#### Load peptideGroups ####

pepg_oops <- read.delim("dev/data-raw/STM2457_48h_oops_PeptideGroups.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":"))

colnames(pepg_oops)[grepl("Abundances\\.Grouped", colnames(pepg_oops))] <- paste0("F", rep(1:4, each = 2), c(".Light", ".Heavy"))
colnames(pepg_oops)

pepg_total <- read.delim("dev/data-raw/STM2457_48h_total_PeptideGroups.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":"))

colnames(pepg_total)[grepl("Abundances\\.Grouped", colnames(pepg_total))] <- paste0("F", rep(5:8, each = 2), c(".Light", ".Heavy"))
colnames(pepg_total)

#### summarised experiment ####



se_oops <- QFeatures::readSummarizedExperiment(
  table = pepg_oops,
  ecol = grepl("F.\\.(Light|Heavy)$", colnames(pepg_oops)),
  fnames = "id"
)

se_total <- QFeatures::readSummarizedExperiment(
  table = pepg_total,
  ecol = grepl("F.\\.(Light|Heavy)$", colnames(pepg_oops)),
  fnames = "id"
)

cd <- DataFrame(row.names = paste0("F", rep(1:8, each = 2), c(".Light", ".Heavy")))

cd

aaa <- QFeatures(
  list(
    "oops" = se_oops,
    "total" = se_total
  ),
  
  colData = cd
)


plot(aaa)

# Get data for a single peptide of interest
aaa['EANEILQR:']

# Join data together
ncol(assay(aaa[['oops']]))
ncol(assay(aaa[['total']]))

colnames(assay(aaa[['oops']]))
colnames(assay(aaa[['total']]))

debugonce(joinAssays)
bbb <- joinAssays(aaa, c("oops", "total"), name = "peptides")

bbb
View(assay(bbb[['peptides']]))
bbb[['peptides']]

plot(bbb)


ccc <- aggregateFeatures(bbb, i='peptides', fcol = 'Master.Protein.Accessions', name = 'protein', fun = 'median')
View(rowData(bbb[['peptides']]))

# Need common master proteins before being able to aggregateFeatures

#### give

meta <- data.frame(
  file = rep(paste0("F", 1:4), each = 2),
  label = rep(c("Light", "Heavy"), 4),
  drug = rep(c("STM2120", "STM2457", "STM2457", "STM2120"), 2)
)




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

