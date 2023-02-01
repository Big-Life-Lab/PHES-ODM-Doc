# Utility function to check for column existence in data_source
has_column_for_table <- function(data_source, table_name, column_name){
  column_is_valid <- TRUE
  if(is.null(data_source[[column_name]])){
    warning(glue::glue('{table_name} table does not have a valid {column_name} column'))
    column_is_valid <- FALSE
  }
  return(column_is_valid)
}

modify_and_check_glue_input <- function(string_to_check, part_ID, string_source_name){
  if(is.null(string_to_check) || length(string_to_check)<1){
    warning(glue::glue('{part_ID} is missing its {string_source_name} column'))
    string_to_check <- ""
  }
  return(string_to_check)
}