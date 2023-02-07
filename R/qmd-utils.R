#' Has Column for Table
#' 
#' Function to check for existence of column in data source. 
#' Creates an appropriate warning and returns boolean based on its presence.
#' 
#' @param data_source data.frame which might contain the column.
#' @param table_name the name of the table whose column is being checked.
#' @param column_name the name of the column being checked.
#' 
#' @return boolean equal to existence of column_name column in data_source.
has_column_for_table <-
  function(data_source, table_name, column_name) {
    column_is_valid <- TRUE
    if (is.null(data_source[[column_name]])) {
      warning(glue::glue(
        '{table_name} table does not have a valid {column_name} column'
      ))
      column_is_valid <- FALSE
    }
    return(column_is_valid)
  }

#' Format Input
#' 
#' Formats input to make it compliant with glue,
#' as well as issuing warning to the location of missing data.
#' 
#' @param string_to_check the string being checked for being empty.
#' @param part_ID Id of the part in string to check, optional parameter used in construction of the warning.
#' @param string_source_name Name of the table string_to_check comes from, optional parameter used in construction of the warning.
#' @param optional_warning A warning overwrite string to bypass warning creation when partID or table name are missing.
#' 
#' @return string_to_check as is or modified into "" if it fails the check.
format_input <-
  function(string_to_check,
           part_ID = NULL,
           string_source_name = NULL,
           optional_warning = NULL) {
    if (is.null(string_to_check) ||
        length(string_to_check) < 1 ||
        is.na(string_to_check) || string_to_check == "NA") {
      # Check for proper function usage
      if (is.null(part_ID) && is.null(string_source_name)) {
        if (is.null(optional_warning)) {
          stop(
            glue::glue(
              'Improper format_input function arguments. If part_ID and string_source_name are empty optional_warning must not be empty'
            )
          )
        } else {
          warning(optional_warning)
          string_to_check <- ""
        }
      }else {
        warning(glue::glue(
          '{part_ID} is missing its {string_source_name} column information'
        ))
        string_to_check <- ""
      }
      
    }
    return(string_to_check)
  }