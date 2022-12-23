#mod_sql_table_sub_categories("rvml/main.sqlite", "cat_info", "parts")

mod_sql_table_sub_categories <- function(main_db_path, col_name, table_name){


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

mod_sql_table_table_of_content <- function(main_db_path, in_table_name, out_table_name, out_table_with_categories_name){
  
  main_db <- DBI::dbConnect(RSQLite::SQLite(), main_db_path)
  quary <- paste("SELECT", "*", "FROM", in_table_name)
  val_table <- DBI::dbGetQuery(main_db, quary)
  val_table <- val_table[grepl("^NA", rownames(val_table))==F,]
  val_table[["sub_categories_string"]] <- ""
  table_info <- val_table[val_table$partType=="table", ]
  
  
  table_with_categories <- data.frame()
  
  RSQLite::dbWriteTable(
    conn = main_db,
    name = out_table_name,
    value = table_info,
    row.names = FALSE,
    header = TRUE,
    overwrite=TRUE
  )
  
  for (row_index in 1:nrow(table_info)) {
    if(is.na(table_info[row_index, ]$partType)){
      next()
    }
    working_row <- table_info[row_index, ]
    table_name <- working_row$partID
    
    valid_sub_categories <- val_table[val_table[[table_name]]!="NA" & !is.na(val_table[[table_name]]), ]
    if (nrow(valid_sub_categories) > 0) {
      for (sub_categories_index in 1:nrow(valid_sub_categories)) {
        sub_working_row <- valid_sub_categories[sub_categories_index,]
        
        if (sub_working_row$partType == "catSet") {
          sub_categories_info <- "<ul>"
          working_cat_set_ID <- sub_working_row$catSetID
          matching_sub_categories <-
            val_table[val_table$catSetID == working_cat_set_ID &
                        val_table$partID != sub_working_row$partID, ]
          for (matching_sub_categories_index in 1:nrow(matching_sub_categories)) {
            sub_sub_working_row <-
              matching_sub_categories[matching_sub_categories_index, ]
            if (nrow(sub_sub_working_row) > 0 && !is.na(sub_sub_working_row$partLabel)) {
              if (sub_sub_working_row$partLabel == "NA") {
                next
              }
              
              sub_categories_info <-
                paste0(
                  sub_categories_info,
                  "<li>",
                  sub_sub_working_row$partID,
                  ": ",
                  sub_sub_working_row$partLabel,
                  "</li>"
                )
            }
          }
          sub_categories_info <- paste0(sub_categories_info, "</ul>")
          valid_sub_categories[valid_sub_categories$partID == sub_working_row$partID, "sub_categories_string"] <-
            sub_categories_info
        }
        
      }
    }
    
    order_name <- paste0(table_name, "Order")
    if(nrow(valid_sub_categories)>0 && !is.null(valid_sub_categories[[order_name]])){
    valid_sub_categories<- valid_sub_categories[order(valid_sub_categories[[order_name]]), ]
    }
    
    tmp_table <- rbind(working_row, valid_sub_categories)
    table_with_categories <- rbind(table_with_categories, tmp_table)
    
  }
  
  RSQLite::dbWriteTable(
    conn = main_db,
    name = out_table_with_categories_name,
    value = table_with_categories,
    row.names = FALSE,
    header = TRUE,
    overwrite=TRUE
  )
  
  DBI::dbDisconnect(main_db)
}