# Source constants when not using pkg.env
source(file.path(getwd(), "R", "constants.R"))
#' Format Table
#'
#' Formats table based on columns_to_format replacing any NA, "NA", or NULL with "N/A"
#'
#' @param input_table data.frame to format
#' @param columns_to_format vector containing names of columns to format. If not passed all columns are formatted.
#' @param remove_duplicate boolean to toggle duplicate partID removal.
#'
#' @return data.frame containing formatted input
format_table <-
  function(input_table,
           columns_to_format = NULL,
           remove_duplicate = FALSE) {
    table_being_checked <- "parts"
    replace_value <- constants$dictionary_missing_value_replacement
    ID_column_name <- parts_sheet_column_names$part_ID_column_name
    status_column_name <-
      parts_sheet_column_names$part_status_column_name
    
    # Format all columns if columns_to_format is null
    if (is.null(columns_to_format)) {
      columns_to_format <- colnames(input_table)
    }
    
    # Copy over input_table
    output_table <- input_table
    
    # Remove parts under development
    if (!is.null(input_table[[status_column_name]])) {
      output_table <-
        output_table[output_table[[status_column_name]] %!=na% constants$part_sheet_status_is_development,]
    }
    
    # Strip off rows where partID is invalid
    output_table <-
      output_table[!is.na(output_table[[ID_column_name]]) &
                     !is.null(output_table[[ID_column_name]]) &
                     length(output_table[[ID_column_name]]) > 0, ]
    # Remove rows with duplicate partID
    if (remove_duplicate) {
      duplicated_rows <-
        output_table[duplicated(output_table[[ID_column_name]]),]
      output_table <-
        output_table[!duplicated(output_table[[ID_column_name]]),]
      # Display warning for removed duplicated rows
      removed_ID_names <- unique(duplicated_rows[[ID_column_name]])
      warning(
        glue::glue(
          '{removed_ID_names} ID contais duplicate {ID_column_name} only the first instance is used.

                           '
        )
      )
    }
    
    
    # Loop over passed columns
    for (current_column_to_format in columns_to_format)
    {
      # Append then skip over columns missing from the input_table and issue appropriate warning
      if (is.null(input_table[[current_column_to_format]])) {
        warning(
          glue::glue(
            '{current_column_to_format} is missing from {table_being_checked} sheet.
          New column was created with {replace_value} values.

          '
          )
        )
        output_table[[current_column_to_format]] <- replace_value
        next()
      }
      # Format missing/improper values into replace_value
      output_table[is.na(output_table[[current_column_to_format]]) |
                     is.null(output_table[[current_column_to_format]]) |
                     length(output_table[[current_column_to_format]]) < 1, current_column_to_format] <-
        replace_value
      
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
            invalid_parts_info[[parts_sheet_column_names$part_ID_column_name]]
          warning(
            glue::glue(
              'Part ID: {partID} contains an invalid value({single_value}), in column: {table_column}.\n\n'
            )
          )
        }
      }
    }
  }

#' Format part table
#'
#' A wrapper function that combines format_table and check_values_for_table.
#' Both formatting the table and displaying table data specific warnings.
#'
#' @param parts_table data.frame containing the parts table
#'
#' @return data.frame containing the formated parts table
format_parts_table <- function(parts_table) {
  # Retrieve table related rows then columns
  tables_data <-
    parts_table[parts_table[[parts_sheet_column_names$part_type_column_name]] == constants$part_sheet_part_type_is_table &
                   parts_table[[parts_sheet_column_names$part_status_column_name]] == constants$part_sheet_status_is_active,]
  
  # Utilize tables_data to generate names of table specific columns
  all_required_column_names <-
    glue::glue('{tables_data[[parts_sheet_column_names$part_ID_column_name]]}Required')
  all_order_column_names <-
    glue::glue('{tables_data[[parts_sheet_column_names$part_ID_column_name]]}Order')
  all_table_column_names <-
    tables_data[[parts_sheet_column_names$part_ID_column_name]]
  table_name_columns <-
    c(all_table_column_names,
      all_required_column_names,
      all_order_column_names)
  
  # Perform regular table_formatting
  formatted_parts_table <- format_table(parts_table, table_name_columns)
  
  check_values_for_table(
    formatted_parts_table,
    all_table_column_names,
    c(
      constants$part_sheet_table_column_type_is_PK,
      constants$part_sheet_table_column_type_is_FK,
      constants$part_sheet_table_column_type_is_header,
      constants$part_sheet_table_column_type_is_input,
      constants$dictionary_missing_value_replacement
    )
  )
  
  return(output_table)
}
