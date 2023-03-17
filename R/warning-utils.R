# Source constants
source("R/constants.R")

missing_warning <- function(context, ID){
  glue::glue('Part {context} is missing for {ID}.\n')
}
missing_and_substituted <- function(ID, context, replacement){
  glue::glue(
    '{ID} is missing a valid {context} substituting {replacement} instead.\n')
}

skipped_and_missing <- function(ID){
  glue::glue('{ID} is missing from parts and will be skipped.\n')
}

skipped_and_invalid <- function(ID){
  glue::glue('{ID} does not have any valid columns and will be skipped.\n')
}

skipped_order <- function(ID){
  glue::glue('{ID} does not have a valid order column. No ordering was done.\n')
}

ivalid_cat_link <- function(ID){
  glue::glue('{ID} has data type of \\
                   {constants$data_type_is_categorical} but no valid \\
                   {parts_sheet_column_names$part_cat_set_ID_column_name}')
}
duplicate_ID <- function(ID){
  glue::glue('Duplicate ID: {ID} found only the first instance is used.')
}
column_missing_and_populated <- function(column_name){
  glue::glue('{column_name} is missing from the sheet.
          New column was created.')
}