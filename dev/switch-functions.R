# option 1
test_fn <- function(type = c("lfq", "tmt", "silac"), text = "sometext!!") {
  type <- match.arg(type)
  
  switch(
    type, 
    lfq = stop(paste("LFQ not implemented yet", text)),
    tmt = stop(paste("TMT not implemented yet", text)),
    silac = print(paste("do something", text)),
    stop("type must be lfq, tmt or silac")
  )
}

to_print = "akakakakaka"
test_fn("silac", to_print)

# option 2

test_fn2 <- function(type = c("lfq", "tmt", "silac")) {
  type <- match.arg(type)
  
  process_fun <- get(paste0("parse_", type))
  
  process_fun()
}

parse_lfq <- function() {
  stop("LFQ not implemented yet")
}

parse_tmt <- function() {
  stop("TMT not implemented yet")
}

parse_silac <- function() {
  print("do something")
}

test_fn2("silac")
