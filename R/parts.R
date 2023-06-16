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
    parts_table[parts_table[[parts_sheet_column_names$part_type_column_name]] == parts$part_type_is_table &
                  parts_table[[parts_sheet_column_names$part_status_column_name]] == parts$status_is_active,]
  
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
      parts$part_sheet_table_column_type_is_PK,
      parts$part_sheet_table_column_type_is_FK,
      parts$part_sheet_table_column_type_is_header,
      parts$part_sheet_table_column_type_is_input,
      odm_dictionary$dictionary_missing_value_replacement
    )
  )
  
  return(formatted_parts_table)
}
