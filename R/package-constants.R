pkg.env <- new.env(parent = emptyenv())

pkg.env$dictionary_directory <- "/data/raw"

pkg.env$parts_sheet_name <- "parts"

# Column names
pkg.env$part_ID_column_name <- "partID"
pkg.env$part_status_column_name <- "status"
pkg.env$part_label_column_name <- "partLabel"
pkg.env$part_description_column_name <- "partDesc"
pkg.env$part_instruction_column_name <- "partInstr"
pkg.env$part_type_column_name <- "partType"
pkg.env$part_domain_ID_column_name <- "domainID"
pkg.env$part_speciment_set_column_name <- "specimenSet"
pkg.env$part_comp_set_column_name <- "compSet"
pkg.env$part_group_ID_column_name <- "groupID"
pkg.env$part_class_ID_column_name <- "classID"
pkg.env$part_nomenclature_ID_column_name <- "nomenclatureID"
pkg.env$part_ontology_reference_column_name <- "ontologyRef"
pkg.env$part_cat_set_ID_column_name <- "catSetID"
pkg.env$part_unit_set_ID_column_name <- "unitSetID"
pkg.env$part_agg_scale_ID_column_name <- "aggScaleID"
pkg.env$part_quality_set_ID_column_name <- "qualitySetID"
pkg.env$part_ref_link_column_name <- "refLink"
pkg.env$part_data_type_column_name <- "dataType"
pkg.env$part_min_value_column_name <- "minValue"
pkg.env$part_max_value_column_name <- "maxValue"
pkg.env$part_min_length_column_name <- "minLength"
pkg.env$part_max_length_column_name <- "maxLength"
pkg.env$part_first_release_column_name <- "firstReleased"
pkg.env$part_last_updated_column_name <- "lastUpdated"

# Column values
pkg.env$part_sheet_part_type_is_table <- "table"
pkg.env$part_sheet_status_is_active <- "active"
pkg.env$part_sheet_data_type_is_categorical <- "categorical"

# Table column values
pkg.env$part_sheet_table_column_type_is_PK <- "pk"
pkg.env$part_sheet_table_column_type_is_FK <- "fk"
pkg.env$part_sheet_table_column_type_is_header <- "header"

# String set Values
pkg.env$part_sheet_table_column_type_set_PK <- "Primary Key"
pkg.env$part_sheet_table_column_type_set_FK <- "Foreign Key"
pkg.env$part_sheet_table_column_type_set_header <- "Header"
  