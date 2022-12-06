#mod_sql_table("rvml/main.sqlite", "cat_info", "parts")

mod_sql_table <- function(main_db_path, col_name, table_name){


main_db <- DBI::dbConnect(RSQLite::SQLite(), main_db_path)
quary <- paste("SELECT", "*", "FROM", table_name, "ORDER BY PartID ASC")
val_table <- DBI::dbGetQuery(main_db, quary)
val_table <- val_table[grepl("^NA", rownames(val_table))==F,]
cat_sets <- val_table[val_table$partType=="catSet", ]
cat_sets[!is.na(cat_sets)]

cat_sets <- unique(cat_sets[["catSetID"]])
cat_sets <- cat_sets[!is.na(cat_sets)]


new_col <- list()

for (single_category in cat_sets) {
  if(single_category=="NA"){
    next
  }
  working_rows <- val_table[val_table$catSetID==single_category & val_table$partType=="category", ]
  part_id <- val_table[val_table$catSetID==single_category & val_table$partType=="catSet", ]
  
  working_rows <- working_rows[grepl("^NA", rownames(working_rows))==F,]
  part_id <- part_id[grepl("^NA", rownames(part_id))==F,]
  
  new_col[[part_id$partID]] <- working_rows$partID
}

new_table <- val_table
new_table[[col_name]] <- ""
insert_template_start <- "<a name=\"{{partID}}\"></a>**{{partLabel}}**"
insert_template_end <-
for (single_partID in names(new_col)) {
  
  sub_categories <- new_col[[single_partID]]
  col_value <- ""
  for (single_categorie in sub_categories) {
    col_value <- paste0(col_value, "<a href=\"#",single_categorie,"\">",single_categorie,"</a></br>")
  }
  new_table[[col_name]][new_table$partID == single_partID] <- col_value
  
}

RSQLite::dbWriteTable(
  conn = main_db,
  name = "parts",
  value = new_table,
  row.names = FALSE,
  header = TRUE,
  overwrite=TRUE
)

DBI::dbDisconnect(main_db)
}