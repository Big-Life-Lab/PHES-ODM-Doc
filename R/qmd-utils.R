# Utility function to check for column existence in data_source
has_column_for_table <- function(data_source, table_name, column_name){
  column_is_valid <- TRUE
  if(is.null(data_source[[column_name]])){
    warning(glue::glue('{table_name} table does not have a valid {column_name} column'))
    column_is_valid <- FALSE
  }
  return(column_is_valid)
}

#create_html_list