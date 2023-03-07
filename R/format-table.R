# Source constants when not using pkg.env
source(file.path(getwd(), "R", "constants.R"))
#' Format Table
#'
#' Formats table based on columns_to_format replacing any NA, "NA", or NULL with "N/A"
#'
#' @param input_table data.frame to format
#' @param columns_to_format vector containing names of columns to format. If not passed all columns are formatted.
#'
#' @return data.frame containing formatted input
format_table <-
  function(input_table,
           columns_to_format = NULL,
           remove_duplicate = FALSE,
           strip_invalid_part_ID = TRUE) {
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
        output_table[output_table[[status_column_name]] %!=na% constants$part_sheet_status_is_development, ]
    }
    
    # Strip off rows where partID is invalid
    if(strip_invalid_part_ID){
    output_table <-
      output_table[!is.na(output_table[[ID_column_name]]) &
                     !is.null(output_table[[ID_column_name]]) &
                     length(output_table[[ID_column_name]]) > 0,]
    }
    # Remove rows with duplicate partID
    if (remove_duplicate) {
      duplicated_rows <-
        output_table[duplicated(output_table[[ID_column_name]]), ]
      output_table <-
        output_table[!duplicated(output_table[[ID_column_name]]), ]
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