#mod_sql_table_sub_categories("data/tables/main.sqlite", "cat_info", "parts")

mod_sql_table_sub_categories <- function(main_db_path, col_name, table_name){


main_db <- DBI::dbConnect(RSQLite::SQLite(), main_db_path)
query <- paste("SELECT", "*", "FROM", table_name, "ORDER BY PartID ASC")
parts_table <- DBI::dbGetQuery(main_db, query)
parts_table <- parts_table[grepl("^NA", rownames(parts_table))==F,]
cat_sets <- parts_table[parts_table$partType=="catSet", ]
cat_sets[!is.na(cat_sets)]

cat_sets <- unique(cat_sets[["catSetID"]])
cat_sets <- cat_sets[!is.na(cat_sets)]


new_col <- list()

for (single_category in cat_sets) {
  if(single_category=="NA"){
    next
  }
  working_rows <- parts_table[parts_table$catSetID==single_category & parts_table$partType=="category", ]
  part_id <- parts_table[parts_table$catSetID==single_category & parts_table$partType=="catSet", ]
  
  working_rows <- working_rows[grepl("^NA", rownames(working_rows))==F,]
  part_id <- part_id[grepl("^NA", rownames(part_id))==F,]
  
  new_col[[part_id$partID]] <- list(partID = working_rows$partID, partLabel = working_rows$partLabel)
}

new_table <- parts_table
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

#' Mod Sql Table Table Of Content
#'
#' Create 2 new sql tables based of in_table. One table contains table of contents for reference table
#' Second table contains the information to populate each table type and as well as their sub categories
#'
#' @param main_db_path System path to the main sqlite database
#' @param in_table_name Represents the name of the sql table data is pulled from
#' @param out_table_name Respresents the name of the sql table containing the table of content table thats created
#' @param out_table_with_categories_name the name of the sql table that contains info on sub categories.
#'
#' @examples
#' mod_sql_table_table_of_content("data/tables/main.sqlite", "parts", "table_of_contents", "cat_tables")
mod_sql_table_table_of_content <- function(main_db_path, in_table_name, out_table_name, out_table_with_categories_name){
  
  main_db <- DBI::dbConnect(RSQLite::SQLite(), main_db_path)
  query <- paste("SELECT", "*", "FROM", in_table_name)
  parts_table <- DBI::dbGetQuery(main_db, query)
  parts_table <- parts_table[grepl("^NA", rownames(parts_table))==F,]
  parts_table[["sub_categories_string"]] <- ""
  table_parts <- parts_table[parts_table$partType=="table", ]
  
  
  table_with_categories <- data.frame()
  
  RSQLite::dbWriteTable(
    conn = main_db,
    name = out_table_name,
    value = table_parts,
    row.names = FALSE,
    header = TRUE,
    overwrite=TRUE
  )
  
  for (row_index in 1:nrow(table_parts)) {
    if(is.na(table_parts[row_index, ]$partType)){
      next()
    }
    current_table_row <- table_parts[row_index, ]
    table_name <- current_table_row$partID
    
    current_table_parts <- parts_table[parts_table[[table_name]]!="NA" & !is.na(parts_table[[table_name]]), ]
    if (nrow(current_table_parts) > 0) {
      for (sub_categories_index in 1:nrow(current_table_parts)) {
        current_column <- current_table_parts[sub_categories_index,]
        
        if (current_column$partType == "catSet") {
          categories_string <- "<ul>"
          working_cat_set_ID <- current_column$catSetID
          matching_sub_categories <-
            parts_table[parts_table$catSetID == working_cat_set_ID &
                        parts_table$partID != current_column$partID, ]
          for (matching_sub_categories_index in 1:nrow(matching_sub_categories)) {
            working_category_row <-
              matching_sub_categories[matching_sub_categories_index, ]
            if (nrow(working_category_row) > 0 && !is.na(working_category_row$partLabel)) {
              if (working_category_row$partLabel == "NA") {
                warning(glue::glue('{working_category_row$partID} has label set to NA'))
                working_category_row$partLabel <- "Missing part label"
              }
              
              categories_string <-
                paste0(
                  categories_string,
                  "<li>",
                  working_category_row$partID,
                  ": ",
                  working_category_row$partLabel,
                  "</li>"
                )
            }
          }
          categories_string <- paste0(categories_string, "</ul>")
          current_table_parts[current_table_parts$partID == current_column$partID, "sub_categories_string"] <-
            categories_string
        }
        
      }
    }
    
    table_order_column <- paste0(table_name, "Order")
    if(nrow(current_table_parts)>0 && !is.null(current_table_parts[[table_order_column]])){
    current_table_parts<- current_table_parts[order(current_table_parts[[table_order_column]]), ]
    }
    
    tmp_table <- rbind(current_table_row, current_table_parts)
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