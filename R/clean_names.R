#' Clean object names
#' 
#' @description Resulting names of object are unique and consist only of 
#' underscores, numbers and letters. 
#'
#' @param dat Input object, typically a `data.frame`.
#'
#' @return Returns `dat` with new, clean names.
#' @source Slightly modified copy of `old_make_clean_names()` from the 
#' [{janitor}](https://github.com/sfirke/janitor) package (MIT license).
#'  
#' @export
#' 
#' @examples
#' df <- data.frame(
#'   `This.is__a...%..Really_horrific_name` = 1:10,
#'   `and....this is also (really) bad_` = 1:10
#' ) |> 
#'   clean_names()
#'   
#' names(df)
#' 
clean_names <- function(dat) {
  if (is.null(names(dat)) && is.null(dimnames(dat))) {
    stop(
      "`clean_names()` requires that either names or dimnames be non-null.",
      call. = FALSE
    )
  }
  
  if (is.null(names(dat))) {
    dimnames(dat) <- lapply(dimnames(dat), old_make_clean_names)
  } else {
    names(dat) <- old_make_clean_names(names(dat))
  }
  
  dat
}

# copy of clean_names from janitor v0.3 on CRAN, to preserve old behavior
old_make_clean_names <- function(string) {
  
  # Takes a data.frame, returns the same data frame with cleaned names
  old_names <- string
  new_names <- old_names |> 
    gsub("'", "", x = _) |>  # remove quotation marks
    gsub("\"", "", x = _) |>  # remove quotation marks
    gsub("%", "percent", x = _) |> 
    gsub("^[ ]+", "", x = _) |> 
    make.names() |> 
    gsub("[.]+", "_", x = _) |>  # convert 1+ periods to single _
    gsub("[_]+", "_", x = _) |>  # fix rare cases of multiple consecutive underscores
    tolower() |> 
    gsub("_$", "", x = _) # remove string-final underscores
  
  # Handle duplicated names - they mess up dplyr pipelines
  # This appends the column number to repeated instances of duplicate variable names
  dupe_count <- vapply(
    seq_along(new_names), function(i) {
      sum(new_names[i] == new_names[1:i])
    }, integer(1)
  )
  
  new_names[dupe_count > 1] <- paste(
    new_names[dupe_count > 1],
    dupe_count[dupe_count > 1],
    sep = "_"
  )
  
  new_names
}
