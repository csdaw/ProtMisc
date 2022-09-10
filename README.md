proteotools
================

## Dependency tree

``` r
library(miniCRAN)
bioc_url <- BiocManager::repositories()[1]
bioc_url
```

    ##                                      BioCsoft 
    ## "https://bioconductor.org/packages/3.14/bioc"

``` r
pkgs <- pkgDep(
  "QFeatures",
  repos = c(CRAN = "https://cran.r-project.org",
            Bioc = bioc_url),
  includeBasePkgs = TRUE,
  suggests = FALSE
)

sort(pkgs)
```

    ##  [1] "AnnotationFilter"     "askpass"              "base64enc"           
    ##  [4] "Biobase"              "BiocGenerics"         "bitops"              
    ##  [7] "cli"                  "clue"                 "cluster"             
    ## [10] "colorspace"           "cpp11"                "crosstalk"           
    ## [13] "curl"                 "data.table"           "DelayedArray"        
    ## [16] "digest"               "dplyr"                "ellipsis"            
    ## [19] "fansi"                "farver"               "fastmap"             
    ## [22] "generics"             "GenomeInfoDb"         "GenomeInfoDbData"    
    ## [25] "GenomicRanges"        "ggplot2"              "glue"                
    ## [28] "graphics"             "grDevices"            "grid"                
    ## [31] "gtable"               "htmltools"            "htmlwidgets"         
    ## [34] "httr"                 "igraph"               "IRanges"             
    ## [37] "isoband"              "jsonlite"             "labeling"            
    ## [40] "later"                "lattice"              "lazyeval"            
    ## [43] "lifecycle"            "magrittr"             "MASS"                
    ## [46] "Matrix"               "MatrixGenerics"       "matrixStats"         
    ## [49] "methods"              "mgcv"                 "mime"                
    ## [52] "MsCoreUtils"          "MultiAssayExperiment" "munsell"             
    ## [55] "nlme"                 "openssl"              "pillar"              
    ## [58] "pkgconfig"            "plotly"               "promises"            
    ## [61] "ProtGenerics"         "purrr"                "QFeatures"           
    ## [64] "R6"                   "RColorBrewer"         "Rcpp"                
    ## [67] "RCurl"                "rlang"                "S4Vectors"           
    ## [70] "scales"               "splines"              "stats"               
    ## [73] "stats4"               "SummarizedExperiment" "sys"                 
    ## [76] "tibble"               "tidyr"                "tidyselect"          
    ## [79] "tools"                "utf8"                 "utils"               
    ## [82] "vctrs"                "viridisLite"          "withr"               
    ## [85] "XVector"              "yaml"                 "zlibbioc"
