# Source constants when not using pkg.env
source(file.path(getwd(), "R", "constants.R"))

#' Verify Input
#'
#' Higher level function to determine appropriate verification function to use
#'
#' @param input_to_check string or list of strings to check
#' @param warning_text warning to display
#'
#' @return Boolean matching appropriate function's return
verify_input <- function(input_to_check, warning_text) {
  is_valid_input <- TRUE
  if (length(input_to_check) > 1) {
    is_valid_input <- verify_column(input_to_check, warning_text)
  } else {
    is_valid_input <- verify_string(input_to_check, warning_text)
  }
  return(is_valid_input)
}

#' Verify Column
#'
#' Function to check if column was created by format_table.
#' Creates an appropriate warning and returns FALSE if
#' column only contains constants$dictionary_missing_value_replacement.
#'
#' @param column_to_check column values to check.
#' @param warning_text warning to display if column was created with only constants$dictionary_missing_value_replacement
#'
#' @return Boolean equal to if column was created with only constants$dictionary_missing_value_replacement
verify_column <-
  function(column_to_check, warning_text) {
    is_valid_column <- TRUE
    if (length(unique(column_to_check)) == 1 &&
        unique(column_to_check) == constants$dictionary_missing_value_replacement) {
      is_valid_column <- FALSE
      warning(warning_text)
    }
    return(is_valid_column)
  }

#' Verify String
#'
#' Verify that input contains values not equal to constants$dictionary_missing_value_replacement
#'
#' @param string_to_check String to check for matching constants$dictionary_missing_value_replacement
#' @param warning_text Warning to issue if string to check is constants$dictionary_missing_value_replacement
#'
#' @return Boolean equal to string to check matching constants$dictionary_missing_value_replacement or not
verify_string <-
  function(string_to_check,
           warning_text) {
    is_valid_string <- TRUE
    if (string_to_check == constants$dictionary_missing_value_replacement) {
      is_valid_string <- FALSE
      warning(glue::glue('{warning_text}
                         
                         '))
    }
    return(is_valid_string)
  }

verify_and_append_content <-
  function(existing_content,
           content_to_verify,
           verify_warning,
           is_valid_insert,
           is_invalid_insert) {
    return_content <- ""
    if(verify_input(content_to_verify, verify_warning)){
      return_content <- glue::glue('{existing_content}{is_valid_insert}')
    }else{
      return_content <- glue::glue('{existing_content}{is_invalid_insert}')
    }
    
    return(return_content)
  }