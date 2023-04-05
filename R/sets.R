#' Bullet point template population
#' 
#' Populates the bullet point template with preset inputs.
#' 
#' @param part_info data.table containing raw parts information.
#' @param part_bullet_template string containing display the bullet display template.
#' 
#' @return glue object string populated using part_info.
bullet_point_template_population <- function(part_info, part_bullet_template){
  # Declare display elements
  part_ID <- part_info[[parts_sheet_column_names$part_ID_column_name]]
  part_input <- list()
  part_input[["partID"]] <- part_ID
  part_input[["partLabel"]] <-
    part_info[[parts_sheet_column_names$part_label_column_name]]
  part_input[["partDesc"]] <-
    part_info[[parts_sheet_column_names$part_description_column_name]]
  part_input[["status"]] <-
    part_info[[parts_sheet_column_names$part_status_column_name]]
  part_input[["firstReleased"]] <-
    part_info[[parts_sheet_column_names$part_first_release_column_name]]
  part_input[["lastUpdated"]] <-
    part_info[[parts_sheet_column_names$part_last_updated_column_name]]
  
  
  
  return(generate_display(part_bullet_template, part_input, part_ID))
}