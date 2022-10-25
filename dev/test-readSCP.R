library(QFeatures)
library(dplyr)
library(tidyr)
library(scp)

## Loading PSMs into qFeatures as is
psms2 <- read.delim("dev/data-raw/RNA_IP_rand_PSMs.txt") %>% 
  rename(Apple = File.ID,
         Banana = Precursor.Abundance)

meta <- data.frame(Apple = unique(psms2$Apple),
                   Grape = 'Banana')

test_qf <- readSCP(psms2,
                   meta,
                   channelCol = 'Grape',
                   batchCol = 'Apple')

colData(test_qf)
rowData(test_qf)
test_qf[[1]] %>% assay() %>% head()

## Loading PSMs into qFeatures, pivoting the channels wider
# Need psm to peptide mapping also

psm2pep <- read.delim("dev/data-raw/RNA_IP_rand_PeptideGroups_PSMs.txt")

psms2 <- read.delim("dev/data-raw/RNA_IP_rand_PSMs.txt") %>% 
  left_join(psm2pep, by = c("PSMs.Workflow.ID", "PSMs.Peptide.ID"))

psms2[psms2$Quan.Channel == "", 'Quan.Channel'] <- "Ambiguous"
psms2 <- psms2 %>% 
  pivot_wider(names_from = Quan.Channel,
              names_sep = ".",
              values_from = Precursor.Abundance) %>% 
  rename(Apple = File.ID)
  

meta <- data.frame(Apple = rep(unique(psms2$Apple), each=2),
                   Grape = rep(c("Light", "Heavy"), 4))

test_qf <- readSCP(psms2,
                   meta,
                   channelCol = 'Grape',
                   batchCol = 'Apple')


colData(test_qf)
rowData(test_qf)
dim(test_qf[[1]])
test_qf[[1]] %>% assay() %>% head()
test_qf[[1]] %>% rowData() %>% head()
test_qf[[2]] %>% rowData() %>% head()
test_qf[[3]] %>% rowData() %>% head()
test_qf[[4]] %>% rowData() %>% head()

test_qf[[4]] %>% rowData() %>% colnames() == test_qf[[2]] %>% rowData() %>% colnames()

## Try linking peptideGroups data...
pep2 <- read.delim("dev/data-raw/RNA_IP_rand_PeptideGroups.txt")

# Create SingleCellExperiment Object
pep3 <- readSingleCellExperiment(pep2, 
                                 ecol = grep("^Abundances.Grouped",
                                             colnames(pep2)))

# Rename columns so they match with PSM data
colnames(test_qf)

colnames(pep3) %>% 
  sub("^Abundances\\.Grouped\\.", "", .) %>% 
  sub("\\.(?=(Light$|Heavy$))", "", ., perl = TRUE) -> colnames(pep3)
colnames(pep3)


# Name rows with some unique identifier for now
rownames(pep3) <- rowData(pep3)$Peptide.Groups.Peptide.Group.ID
pep3

# Include the peptide data in the QFeatures object
test_qf2 <- addAssay(test_qf, pep3, name = 'peptides')

# Link the PSMs and the peptides
test_qf2 <- addAssayLink(test_qf2,
                         from = 1:4,
                         to = 'peptides',
                         varFrom = rep("Peptide.Groups.Peptide.Group.ID", 4),
                         varTo = "Peptide.Groups.Peptide.Group.ID")

# This particular peptide should have 28 PSMs
test_qf2['69051'][[5]] %>% rowData()
test_qf2['69051']
