constants <- list()
parts_sheet_column_names <- list()
sets_sheet_column_names <- list()

constants$dictionary_directory <- "data/raw"

constants$dictionary_missing_value_replacement <- "NA"

constants$parts_sheet_name <- "parts"
constants$parts_file_name <- "parts"
constants$sets_sheet_name <- "sets"
constants$sets_file_name <- "sets"

# Column names for the parts sheet
parts_sheet_column_names$part_ID_column_name <- "partID"
parts_sheet_column_names$part_status_column_name <- "status"
parts_sheet_column_names$part_label_column_name <- "partLabel"
parts_sheet_column_names$part_description_column_name <- "partDesc"
parts_sheet_column_names$part_instruction_column_name <- "partInstr"
parts_sheet_column_names$part_type_column_name <- "partType"
parts_sheet_column_names$part_domain_ID_column_name <- "domain"
parts_sheet_column_names$part_speciment_set_column_name <- "specimenSet"
parts_sheet_column_names$part_comp_set_column_name <- "compartmentSet"
parts_sheet_column_names$part_group_ID_column_name <- "group"
parts_sheet_column_names$part_class_ID_column_name <- "class"
parts_sheet_column_names$part_nomenclature_ID_column_name <- "nomenclature"
parts_sheet_column_names$part_ontology_reference_column_name <- "ontologyRef"
parts_sheet_column_names$part_cat_set_ID_column_name <- "mmaSet"
parts_sheet_column_names$part_unit_set_ID_column_name <- "unitSet"
parts_sheet_column_names$part_agg_scale_ID_column_name <- "aggregationScale"
parts_sheet_column_names$part_quality_set_ID_column_name <- "qualitySet"
parts_sheet_column_names$part_ref_link_column_name <- "refLink"
parts_sheet_column_names$part_data_type_column_name <- "dataType"
parts_sheet_column_names$part_min_value_column_name <- "minValue"
parts_sheet_column_names$part_max_value_column_name <- "maxValue"
parts_sheet_column_names$part_min_length_column_name <- "minLength"
parts_sheet_column_names$part_max_length_column_name <- "maxLength"
parts_sheet_column_names$part_first_release_column_name <- "firstReleased"
parts_sheet_column_names$part_last_updated_column_name <- "lastUpdated"

# Column names for sets sheet
sets_sheet_column_names$part_set_type_column_name <- "setType"
sets_sheet_column_names$part_set_ID_column_name <- "set"
# Column values
constants$part_sheet_part_type_is_table <- "tables"
constants$part_sheet_status_is_active <- "active"
constants$part_sheet_status_is_development <- "development"
constants$part_sheet_data_type_is_categorical <- "categorical"
constants$set_type_is_dictSet <- "dictSet"
constants$set_type_is_catSet <- "catSet"
constants$set_ID_is_list_set <- "listSet"

# Table column values
constants$part_sheet_table_column_type_is_PK <- "pk"
constants$part_sheet_table_column_type_is_FK <- "fk"
constants$part_sheet_table_column_type_is_header <- "header"

# String set Values
constants$part_sheet_table_column_type_set_PK <- "Primary Key"
constants$part_sheet_table_column_type_set_FK <- "Foreign Key"
constants$part_sheet_table_column_type_set_header <- "Header"
  