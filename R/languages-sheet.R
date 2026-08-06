source(file.path(getwd(), "R", "sheet-metadata.R"))

languages <- list(
  lang = list(
    name = "lang"
  ),
  lang_fam = list(
    name = "langFam"
  ),
  lang_name = list(
    name = "langName"
  ),
  natName = list(
    name = "natName"
  ),
  iso6391 = list(
    name = "iso6391"
  ),
  iso6392T = list(
    name = "iso6392T"
  ),
  firstReleased = list(
    name = "firstReleased"
  ),
  lastUpdated = list(
    name = "lastUpdated"
  ),
  changes = list(
    name = "changes"
  ),
  notes = list(
    name = "notes"
  )
)
languages_sheet_column_names <- get_column_names(languages)
