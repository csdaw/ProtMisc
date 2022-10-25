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
psms2 <- read.delim("dev/data-raw/RNA_IP_rand_PSMs.txt")

psms2[psms2$Quan.Channel == "", 'Quan.Channel'] <- "Ambiguous"
psms2 <- psms2 %>% 
  pivot_wider(names_from = Quan.Channel,
              names_prefix = "Abundance.",
              values_from = Precursor.Abundance) %>% 
  rename(Apple = File.ID)
  

meta <- data.frame(Apple = rep(unique(psms2$Apple), each=2),
                   Grape = rep(c("Abundance.Light", "Abundance.Heavy"), 4))

test_qf <- readSCP(psms2,
                   meta,
                   channelCol = 'Grape',
                   batchCol = 'Apple')


colData(test_qf)
rowData(test_qf)
dim(test_qf[[1]])
test_qf[[1]] %>% assay() %>% head()
test_qf[[1]] %>% rowData() %>% head()

pep2 <- read.delim("dev/data-raw/RNA_IP_rand_PeptideGroups.txt")
