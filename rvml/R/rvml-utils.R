# Shortcut to run
# run_rvml("rvml/main.sqlite", "rvml/localization.sqlite", "rvml/parts-template.md", "parts", "rvml/content")

convert_excel_into_db <- function(path_to_excel, path_to_db) {
  list_of_sheets <- readxl::excel_sheets(path_to_excel)
  db_connection <- DBI::dbConnect(RSQLite::SQLite(), path_to_db)
  
  for (table_name in list_of_sheets) {
    tmp_table <- readxl::read_excel(path_to_excel, sheet = table_name)
    
    # Catch duplicate column names
    col_names <- tolower(colnames(tmp_table))
    if (length(unique(col_names)) < length(col_names)) {
      message(paste(table_name, "contains duplicate column names"))
      next
    }
    
    RSQLite::dbWriteTable(
      conn = db_connection,
      name = table_name,
      value = tmp_table,
      row.names = FALSE,
      header = TRUE,
      overwrite = TRUE
    )
  }
  return(db_connection)
}

# Read in csv into sql db

create_db_from_csv <-
  function(db_file_name, origin_name, db_name) {
    db_connection <- DBI::dbConnect(RSQLite::SQLite(), db_file_name)
    # direct read not working when commas present inside of text
    tmp_table <- readr::read_csv(origin_name)
    # Write csv to db
    RSQLite::dbWriteTable(
      conn = db_connection,
      name = db_name,
      value = tmp_table,
      row.names = FALSE,
      header = TRUE
    )
    
    return(db_connection)
  }