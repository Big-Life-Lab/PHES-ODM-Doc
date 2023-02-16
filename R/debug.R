source("R/qmd-utils.R")

# Read in and prepare data.frames
parts_table <-
  readxl::read_excel(file.path(pkg.env$odm_dictionary_file_path),
                     sheet = pkg.env$parts_sheet_name)
tables_data <-
  parts_table[parts_table[[pkg.env$part_type_column_name]] == pkg.env$part_sheet_part_type_is_table &
                parts_table[[pkg.env$part_status_column_name]] == pkg.env$part_sheet_status_is_active,]

# Declaring string that will be appended during the loops
table_of_content <- glue::glue('## Table list
                               <ul>')
tables_info_display_content <- ""
for (table_row_index in seq_len(nrow(tables_data))) {
  current_table_data <- tables_data[table_row_index, ]
  
  # table_ID is assumed to be always present missing ID means invalid part
  table_ID <- current_table_data[[pkg.env$part_ID_column_name]]
  if (nchar(format_input(table_ID, optional_warning = glue::glue(
    'Found table part with missing partID. Skipping.'
  )))<=0) {
    next()
  }
  
  # Variables being used in table display
  # Their creation is not needed but I believe it assists in clarity
  table_label <- current_table_data[[pkg.env$part_label_column_name]]
  table_label <-
    format_input(table_label, table_ID, pkg.env$part_label_column_name)
  
  table_description <- current_table_data[[pkg.env$part_description_column_name]]
  table_description <- format_input(table_description, table_ID, pkg.env$part_description_column_name)
  
  table_instruction <- current_table_data[[pkg.env$part_instruction_column_name]]
  table_instruction <- format_input(table_instruction, table_ID, pkg.env$part_instruction_column_name)
  
  
  required_column_name <- glue::glue('{table_ID}Required')
  order_column_name <- glue::glue('{table_ID}Order')
  
  # Verify needed column exists
  if (!has_column_for_table(parts_table, table_ID, table_ID)) {
    next()
  }
  
  # Acquire columns that belong to the table
  parts_table[[table_ID]] <-
    tolower(trimws(parts_table[[table_ID]]))
  table_columns <-
    parts_table[parts_table[[table_ID]] == pkg.env$part_sheet_table_column_type_is_PK |
                  parts_table[[table_ID]] == pkg.env$part_sheet_table_column_type_is_FK |
                  parts_table[[table_ID]] == pkg.env$part_sheet_table_column_type_is_header,]
  
  # Check for optional columns
  has_required_column <-
    has_column_for_table(parts_table, table_ID, required_column_name)
  if (has_column_for_table(parts_table, table_ID, order_column_name)) {
    table_columns <-
      table_columns[order(table_columns[[order_column_name]]),]
  }
  
  # Append table of contents
  table_of_content <-
    glue::glue(
      '{table_of_content}<li><a href=\"#{table_ID}\">{table_label}</a></li>'
    )
  
  # Structure of table display
  tables_info_display_content <-
    glue::glue(
      '{tables_info_display_content}
      **{table_label}** <a name=\"{table_ID}\"></a>(<a href=\"/parts.html#{table_ID}\">{table_ID}</a>)
      {table_description} {table_instruction}<ul>'
    )
  
  for (column_row_index in seq_len(nrow(table_columns))) {
    current_table_column <- table_columns[column_row_index, ]
    
    detected_column_role <- current_table_column[[table_ID]]
    column_role <- "NA"
    if (length(detected_column_role) > 0 && !is.na(detected_column_role)) {
      if (tolower(detected_column_role) == pkg.env$parts_sheet_table_column_type_is_FK) {
        column_role <- pkg.env$part_sheet_table_column_type_set_FK
      } else if (tolower(detected_column_role) == pkg.env$parts_sheet_table_column_type_is_PK) {
        column_role <- pkg.env$part_sheet_table_column_type_set_PK
      } else if (tolower(detected_column_role) == pkg.env$parts_sheet_table_column_type_is_header) {
        column_role <- pkg.env$part_sheet_table_column_type_set_header
      } else {
        next()
      }
    }
    
    # Column_ID is assumed to be always present missing ID means invalid part
    column_ID <- current_table_column[[pkg.env$part_ID_column_name]]
    if (nchar(format_input(
      column_ID,
      optional_warning = glue::glue(
        '{table_ID} contains a missing id for one of its columns. Missing columns are skipped'
      )
    ))<=0) {
      next()
    }
    
    # Variables being used in column display
    column_label <- current_table_column[[pkg.env$part_label_column_name]]
    column_label <-
      format_input(column_label, column_ID, pkg.env$part_label_column_name)
    
    column_description <- current_table_column[[pkg.env$part_description_column_name]]
    column_description <-
      format_input(column_description, column_ID, pkg.env$part_description_column_name)
    
    column_requirement <- ""
    if (has_required_column) {
      column_requirement <- current_table_column[[required_column_name]]
      column_requirement <-
        format_input(column_requirement, column_ID, required_column_name)
      # Moving comma insertion here to allow for smoother output
      if (nchar(column_requirement) > 0) {
        column_requirement <- glue::glue(', {column_requirement}')
      }
    }
    
    column_dataType <- current_table_column[[pkg.env$part_data_type_column_name]]
    column_dataType <-
      format_input(column_dataType, column_ID, pkg.env$part_data_type_column_name)
    
    # Structure of column display
    tables_info_display_content <-
      glue::glue(
        '{tables_info_display_content}<li>**{column_label}** (partID: <a href=\"/parts.html#{column_ID}\">{column_ID}</a>). {column_description} Role: {column_role}{column_requirement}. Data type: {column_dataType}.'
      )
    
    # Append link to catSetID if dataType is categorical
    if (column_dataType == pkg.env$part_sheet_data_type_is_categorical) {
      column_catSetID <- current_table_column[[pkg.env$part_cat_set_ID_column_name]]
      column_catSetID <-
        format_input(column_catSetID, table_ID, pkg.env$part_cat_set_ID_column_name)
      if (nchar(column_catSetID) > 0) {
        tables_info_display_content <-
          glue::glue(
            '{tables_info_display_content} CatSet: <a href=\"/sets.html#{column_catSetID}\">{column_catSetID}</a>'
          )
      }
    }
    
    # Close off column list element
    tables_info_display_content <-
      glue::glue('{tables_info_display_content}</li>')
  }
  tables_info_display_content <-
    glue::glue('{tables_info_display_content}</ul>')
}
table_of_content <- glue::glue('{table_of_content}</ul>')