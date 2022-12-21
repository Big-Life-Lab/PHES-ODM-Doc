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
  
  new_col[[part_id$partID]] <- list(partID = working_rows$partID, partLabel = working_rows$partLabel)
}

new_table <- val_table
new_table[[col_name]] <- ""
for (single_partID in names(new_col)) {
  
  sub_categories <- new_col[[single_partID]][[1]]
  col_value <- "Categorical inputs for this part </br><ul>"
  
  # Skip empty cat values for now
  if(length(sub_categories)<1){
    print(paste0(single_partID," is tagged with catSet but has no sub categories"))
    next()
    
  }
  
  for (single_categorie_index in 1:length(sub_categories)) {
    cat_value_ID <- new_col[[single_partID]]$partID[[single_categorie_index]]
    cat_label <- new_col[[single_partID]]$partLabel[[single_categorie_index]]
    col_value <- paste0(col_value, "<li><a href=\"#",cat_value_ID,"\">","**",cat_label,"**", ":(",cat_value_ID,")","</a></li>")
  }
  col_value <- paste0(col_value,"</ul>")
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