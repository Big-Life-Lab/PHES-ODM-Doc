sets <- list(
  set_id = list(
    name = "setID",
    categories = list(
      list_set = "listSet"
    )
  ),
  set_type = list(
    name = "setType",
    categories = list(
      dict_set = "dictSet",
      mma_set = "mmaSet"
    )
  )
)
sets_sheet_column_names <- lapply(sets[names(sets)], `[[`, 1)
