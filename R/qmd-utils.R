# Utility function to check for column existence in data_source
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