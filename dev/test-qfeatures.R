# Numeric data (assay)
## two assays (matrices) with matching column names
m1 <- matrix(1:40, ncol = 4)
m2 <- matrix(1:16, ncol = 4)
sample_names <- paste0("S", 1:4)
colnames(m1) <- colnames(m2) <- sample_names
rownames(m1) <- letters[1:10]
rownames(m2) <- letters[1:4]

m1
m2

# Observation annotation (rowData)
## two corresponding feature metadata with appropriate row names
df1 <- DataFrame(Fa = 1:10, Fb = letters[1:10],
                 row.names = rownames(m1))
df2 <- DataFrame(row.names = rownames(m2))

## Have a look at what we just made
df1
m1

df2
m2

# Make summarisedExperiment objects
(se1 <- SummarizedExperiment(m1, df1))
(se2 <- SummarizedExperiment(m2, df2))

el <- list(assay1 = se1, assay2 = se2)

# Sample annotation (colData)
cd <- DataFrame(Var1 = rnorm(4),
                Var2 = LETTERS[1:4],
                row.names = sample_names)

cd

# Combine in a qFeatures object
fts1 <- QFeatures(el, colData = cd)
fts1

# Filtering/subsetting
## multiassayexperiment[i = rownames, j = primary or colnames, k = assay]

# Filter for observations with rowname 'a' in each experiment
fts1['a']

# Filter for all observations from sample S1 in each experiment
fts1[, 'S1']

# Get only the experiment named 'assay2'
# Produces a warning
fts1[, , 'assay2']

# Extract first experiment by position
fts1[[1]]

# Extract first experiment by name
# Does not produce a warning
fts1[['assay1']]



