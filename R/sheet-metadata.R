#' Get column names
#' 
#' Utility function to extract column names from column metadata
#' 
#' @param column_metadata list containing a sheets column metadata
#' 
#' @return vector containing string column names
get_column_names <- function(column_metadata){
  column_names <- lapply(sets[names(sets)], `[[`, 1)
  # convert to vector
  column_names <- unlist(column_names)
  
  return(column_names)
}