library(camprotR)
library(dplyr)

pepg2psm <- read.delim("dev/data-raw/RNA_IP_rand_PeptideGroups_PSMs.txt")

psms <- read.delim("dev/data-raw/RNA_IP_rand_PSMs.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":")) %>% 
  left_join(pepg2psm, by = c("PSMs.Workflow.ID", "PSMs.Peptide.ID")) %>% 
  select(Peptide.Groups.Peptide.Group.ID, everything())

psms_short <- psms %>% 
  select(Sequence, Modifications, Precursor.Abundance, Master.Protein.Accessions, Protein.Accessions,
         Precursor.Quan.Result.ID, File.ID)

pepg <- read.delim("dev/data-raw/RNA_IP_rand_PeptideGroups.txt") %>% 
  mutate(id = paste(Sequence, Modifications, sep = ":"))

psms_tally <- psms %>% 
  group_by(across(c(Sequence, Modifications))) %>% 
  tally()

all_pepg_seqs <- psms_tally$Sequence

pepg_seqs <- pepg$Sequence %>% sort()

# check number of peptide sequences
nrow(pepg)
nrow(psms_tally)

# pepg seqs are a subset of psms
# but some things in our grouped psms do not make it to pepg
all(pepg_seqs %in% all_pepg_seqs)

# which are they?
missing_pepg <- psms_tally[which(!all_pepg_seqs %in% pepg_seqs), ]
missing_psms <- psms[which(psms$Sequence %in% missing_pepg$Sequence), ]

non_missing_psms <- psms[which(!psms$PSMs.Peptide.ID %in% missing_psms$PSMs.Peptide.ID), ]
non_missing_psms2 <- psms[which(psms$Sequence %in% pepg$Sequence), ]

# missing and non-missing psms should add up to psms
nrow(missing_psms) + nrow(non_missing_psms) == nrow(psms)
nrow(missing_psms) + nrow(non_missing_psms2) == nrow(psms)



psms_of_interest <- psms %>% 
  filter(Sequence == "TNIIPVLEDAR" | Sequence == "VFIGNLNTAIVK")


## MISSING PSMs ARE FOR PEPTIDES WITH ISOLEUCINE/LEUCINE THAT HAS BEEN SWITCHED
## AROUND WITH THE DIFFERENT SEARCH ENGINES


table(pepg2psm$Peptide.Groups.Peptide.Group.ID)
length(unique(pepg2psm$Peptide.Groups.Peptide.Group.ID))

missing_pepg_group_ids <- pepg2psm[which(!pepg2psm$Peptide.Groups.Peptide.Group.ID %in% pepg$Peptide.Groups.Peptide.Group.ID), ]

