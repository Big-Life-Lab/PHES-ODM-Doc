# Source constants when not using pkg.env
source(file.path(getwd(), "R", "odm-dictionary-file.R"))
source(file.path(getwd(), "R", "parts-sheet.R"))
source(file.path(getwd(), "R", "warning-utils.R"))
source(file.path(getwd(), "R", "sets-sheet.R"))
source(file.path(getwd(), "R", "qmd-utils.R"))

#' Format Table
#'
#' Formats table based on columns_to_format replacing any NA, "NA", or NULL with "N/A"
#'
#' @param input_table data.frame to format
#' @param columns_to_format vector containing names of columns to format. If not passed all columns are formatted.
#' @param remove_duplicate boolean to toggle duplicate ID removal.
#' @param strip_invalid_part_ID boolean to toggle removal of invalid IDs in partID column.
#' @param table_being_checked string representing the name of the table being checked.
#' @param replace_value string representing the value to use for replacement of invalid values.
#' @param ID_column_name string representing the name of the ID column for the passed table.
#' @param remove_development_parts boolean to toggle removal of parts in development.
#' @param append_null_columns boolean to toggle appending of new columns when a null column is found.
#' @param replace_invalid_values boolean to toggle replacing of invalid values within a column.
#'
#' @return data.frame containing formatted input
format_table <-
  function(input_table,
           columns_to_format = NULL,
           remove_duplicate = FALSE,
           strip_invalid_part_ID = TRUE,
           table_being_checked = "parts",
           replace_value = odm_dictionary$dictionary_missing_value_replacement,
           ID_column_name = parts$part_id$name,
           remove_development_parts = TRUE,
           append_null_columns = TRUE,
           replace_invalid_values = TRUE) {
    status_column_name <-
      parts$status$name
    
    # Format all columns if columns_to_format is null
    if (is.null(columns_to_format)) {
      columns_to_format <- colnames(input_table)
    }
    
    # Copy over input_table
    output_table <- input_table
    
    # Remove parts under development
    if (!is.null(input_table[[status_column_name]]) && remove_development_parts) {
      output_table <-
        output_table[output_table[[status_column_name]] %!=na% parts$status$categories$development, ]
    }
    
    # Strip off rows where partID is invalid
    if(strip_invalid_part_ID){
    output_table <-
      output_table[!is.na(output_table[[ID_column_name]]) &
                     !is.null(output_table[[ID_column_name]]) &
                     length(output_table[[ID_column_name]]) > 0, ]
    }
    # Remove rows with duplicate partID
    if (remove_duplicate) {
      duplicated_rows <-
        output_table[duplicated(output_table[[ID_column_name]]),]
      output_table <-
        output_table[!duplicated(output_table[[ID_column_name]]),]
      # Display warning for removed duplicated rows
      removed_ID_names <- unique(duplicated_rows[[ID_column_name]])
      if (length(removed_ID_names) > 0) {
        warning(duplicate_ID(removed_ID_names))
      }
    }
    
    
    # Loop over passed columns
    for (current_column_to_format in columns_to_format)
    {
      # Append then skip over columns missing from the input_table and issue appropriate warning
      if (is.null(input_table[[current_column_to_format]])) {
        warning(column_missing_and_populated(current_column_to_format))
        if(append_null_columns) {
          output_table[[current_column_to_format]] <- replace_value
        }
        next()
      }
      # Format missing/improper values into replace_value
      if(replace_invalid_values) {
        output_table[is.na(output_table[[current_column_to_format]]) |
                       is.null(output_table[[current_column_to_format]]) |
                       length(output_table[[current_column_to_format]]) < 1, current_column_to_format] <-
          replace_value
      } 
    }
    
    
    
    return(output_table)
  }


#' Check values for tables
#'
#' Check that values present in the specified columns in the input table match the passed valid_values.
#' Outputs a warning when case sensitive has no match but case insensitive matches.
#'
#' @param input_table data.frame containing input data
#' @param column_names vector of names of the columns within input_table to check
#' @param valid_values vector of valid values withing the columns
check_values_for_table <-
  function(input_table, column_names, valid_values) {
    for (table_column in column_names) {
      unique_values <- unique(input_table[[table_column]])
      for (single_value in unique_values) {
        if (!(single_value %in% valid_values)) {
          # Gather parts info using invalid values
          invalid_parts_info <-
            input_table[input_table[[table_column]] == single_value,]
          partID <-
            invalid_parts_info[[parts$part_id$name]]
          warning(
            glue::glue(
              'Part ID: {partID} contains an invalid value({single_value}), in column: {table_column}.\n\n'
            )
          )
        }
      }
    }
  }

