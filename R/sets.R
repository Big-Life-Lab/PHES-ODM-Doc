source("R/sets-sheet.R")
#' Bullet point template population
#'
#' Populates the bullet point template with preset inputs.
#'
#' @param part_info data.table containing raw parts information.
#' @param part_bullet_template string containing display the bullet display template.
#'
#' @return glue object string populated using part_info.
generate_bullet_point_display <-
  function(part_info, part_bullet_template) {
    # Declare display elements
    part_ID <- part_info[[parts$part_id$name]]
    part_input <- list()
    part_input[["partID"]] <- part_ID
    part_input[["partLabel"]] <-
      part_info[[parts$part_label$name]]
    part_input[["partDesc"]] <-
      part_info[[parts$part_description$name]]
    part_input[["status"]] <-
      part_info[[parts$status$name]]
    part_input[["firstReleased"]] <-
      part_info[[parts$first_released$name]]
    part_input[["lastUpdated"]] <-
      part_info[[parts$last_updated$name]]
    
    
    
    return(generate_display(part_bullet_template, part_input, part_ID))
  }