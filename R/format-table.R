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
           columns_to_format = NULL) {
    
    table_being_checked <- "parts"
    replace_value <- "N/A"
    
    # Format all columns if columns_to_format is null
    if (is.null(columns_to_format)) {
      columns_to_format <- colnames(input_table)
    }
    # Copy over input_table
    output_table <- input_table
    
    # Loop over passed columns
    for (column_to_format in columns_to_format)
    {
      # Skip over columns missing from the input_table and issue appropriate warning
      if(is.null(input_table[[column_to_format]])){
        warning(glue::glue('{column_to_format} is missing from {table_being_checked}'))
        next()
      }
      # Format missing/improper values into replace_value
      output_table[is.na(output_table[[column_to_format]]) |
                     is.null(output_table[[column_to_format]]) |
                     length(output_table[[column_to_format]]) < 1 |
                     output_table[[column_to_format]] == "NA", column_to_format] <-
        replace_value
    }
    
    return(output_table)
  }