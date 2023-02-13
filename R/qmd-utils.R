# Source constants when not using pkg.env
source(file.path(getwd(), "R", "constants.R"))

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
      warning(warning_text)
      is_valid_column <- FALSE
    }
    return(column_is_valid)
  }

#' Verify Input
#'
#' Verify that input contains values not equal to constants$dictionary_missing_value_replacement
#'
#' @param string_to_check String to check for matching constants$dictionary_missing_value_replacement
#' @param warning_text Warning to issue if string to check is constants$dictionary_missing_value_replacement
#'
#' @return Boolean equal to string to check matching constants$dictionary_missing_value_replacement or not
verify_input <-
  function(string_to_check,
           warning_text) {
    is_valid_string <- TRUE
    if (string_to_check == constants$dictionary_missing_value_replacement) {
      is_valid_string <- FALSE
      warning(warning_text)
    }
    return(is_valid_string)
  }