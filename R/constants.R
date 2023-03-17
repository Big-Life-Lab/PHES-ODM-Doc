# Source other constants for easy sourcing
source("R/constants-sets.R")
source("R/constants-parts.R")

constants <- list()
constants$dictionary_directory <- "data/raw"

constants$dictionary_missing_value_replacement <- "NA"

constants$parts_sheet_name <- "parts"
constants$parts_qmd_file_name <- "parts"
constants$sets_sheet_name <- "sets"
constants$sets_qmd_file_name <- "sets"


# Column values
constants$part_type_is_table <- "tables"
constants$status_is_active <- "active"
constants$status_is_development <- "development"
constants$data_type_is_categorical <- "categorical"
constants$set_type_is_dictSet <- "dictSet"
constants$set_type_is_catSet <- "mmaSet"
constants$set_ID_is_list_set <- "listSet"

# Table column values
constants$part_sheet_table_column_type_is_PK <- "pk"
constants$part_sheet_table_column_type_is_FK <- "fk"
constants$part_sheet_table_column_type_is_header <- "header"

# String set Values
constants$part_sheet_table_column_type_set_PK <- "Primary Key"
constants$part_sheet_table_column_type_set_FK <- "Foreign Key"
constants$part_sheet_table_column_type_set_header <- "Header"
  