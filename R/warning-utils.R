# Source constants
source(file.path(getwd(), "R", "parts-sheet.R"))

#' Missing warning.
#' 
#' Warning for when information is missing for a part.
#' 
#' @param column_name string storing the name of the column with missing information. 
#' @param ID string storing the ID of a part with missing information.
#' 
#' @return String with the populated warning about the missing part.
missing_warning <- function(column_name, ID){
  glue::glue('Part {column_name} is missing for {ID}.\n')
}

#' Missing and substituted.
#' 
#' Warning for when information is missing but is replaced with additional information.
#' 
#' @param ID string storing the ID of a part.
#' @param column_name string storing the name of the column with missing information.
#' @param replacement string storing the column name whose values are used as replacement.
#' 
#' @return String with the populated warning about missing and substituted values.
missing_and_substituted <- function(ID, column_name, replacement){
  glue::glue(
    'ID: {ID} is missing a valid {column_name} substituting {replacement} instead.\n')
}

#' Skipped and missing.
#' 
#' Warning for when information is missing and is skipped from display.
#' 
#' @param ID string storing the ID of a part which is skipped.
#' 
#' @return String with the populated warning about skipped parts.
skipped_and_missing <- function(ID){
  glue::glue('ID: {ID} is missing from parts and will be skipped.\n')
}

#' Skipped and invalid.
#' 
#' Warning for when a part that's related to a table has no valid columns 
#' and is skipped for display.
#' 
#' @param ID string containing the ID of a part that does not have valid table columns.
#' 
#' @return String with the populated warning about skipping invalid table partIDs. 
skipped_and_invalid <- function(ID){
  glue::glue('ID: {ID} does not have any valid columns and will be skipped.\n')
}

#' Skipped ordering.
#' 
#' Warning for when no valid order column is found therefore ordering is skipped.
#' 
#' @param ID string containing the ID of a part responsible for a table with no order columns.
#' 
#' @return String with the populated warning explaining skipped ordering when an order column is missing.
skipped_order <- function(ID){
  glue::glue('ID: {ID} does not have a valid order column. No ordering was done.\n')
}

#' Invalid cat link.
#' 
#' Warning for when no valid categorical link is present.
#' 
#' @param ID string containing the ID of a part which does not have a valid category link.
#' 
#' @return String with the populated warning containing explanation of the invalid cat link.
invalid_cat_link <- function(ID){
  glue::glue('ID: {ID} has data type of \\
                   {parts$data_type$categories$categorical} but no valid \\
                   {parts$mma_set$name}.\n')
}

#' Duplicated ID.
#' 
#' Warning for when duplicate IDs are present in the dictionary.
#' 
#' @param ID string containing the ID of a part that has a duplicate row.
#' 
#' @return String with the populated warning stating which ID was duplicate.
duplicate_ID <- function(ID){
  glue::glue('Duplicate ID: {ID} found only the first instance is used.\n')
}

#' Column missing but created and populated.
#' 
#' Warning for when no valid column is found and one is created.
#' 
#' @param column_name string storing the name of the column with missing information.
#' 
#' @return String with the populated warning.
column_missing_and_populated <- function(column_name){
  glue::glue('Column: {column_name} is missing from the sheet. \\
             New column was created.\n\n')
}