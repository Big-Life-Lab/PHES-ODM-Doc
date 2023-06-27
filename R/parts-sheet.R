source(file.path(getwd(), "R", "sheet-metadata.R"))

parts <- list(
  part_id = list(
    name = "partID"
  ),
  status = list(
    name = "status",
    categories = list(
      active = "active",
      development = "development"
    )
  ),
  part_label = list(
    name = "partLabel"
  ),
  part_description = list(
    name = "partDesc"
  ),
  part_instruction = list(
    name = "partInstr"
  ),
  part_type = list(
    name = "partType",
    categories = list(
      table = "tables"
    )
  ),
  domain = list(
    name = "domain"
  ),
  specimen_set = list(
    name = "specimenSet"
  ),
  compartment_set = list(
    name = "compartmentSet"
  ),
  group = list(
    name = "group"
  ),
  class = list(
    name = "class"
  ),
  nomenclature = list(
    name = "nomenclature"
  ),
  ontology_reference = list(
    name = "ontologyRef"
  ),
  mma_set = list(
    name = "mmaSet"
  ),
  unit_set = list(
    name = "unitSet"
  ),
  aggregation_scale = list(
    name = "aggregationScale"
  ),
  quality_set = list(
    name = "qualitySet"
  ),
  reference_link = list(
    name = "refLink"
  ),
  data_type = list(
    name = "dataType",
    categories = list(
      categorical = "categorical"
    )
  ),
  missingness_set = list(
    name = "missingnessSet"
  ),
  min_value = list(
    name = "minValue"
  ),
  max_value = list(
    name = "maxValue"
  ),
  min_length = list(
    name = "minLength"
  ),
  max_length = list(
    name = "maxLength"
  ),
  first_released = list(
    name = "firstReleased"
  ),
  last_updated = list(
    name = "lastUpdated"
  )
)
table_column_metadata = list(
  table = list(
    name = "{table_name}",
    categories = list(
      primary_key = "pk",
      foreign_key = "fk",
      header = "header",
      input = "input"
    )
  ),
  table_required = list(
    name = "{table_name}Required"
  ),
  table_order = list(
    name = "{table_name}Order"
  )
)

parts_sheet_column_names <- get_column_names(parts)


