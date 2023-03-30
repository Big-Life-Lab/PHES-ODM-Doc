#' Generate display string
#' 
#' Populates passed template with values from display_variables after verifying.
#' 
#' @param template string template containing variables to insert surrounded by {}
#' @param display_variables named list with values to insert where name is equal to name in template
#' @param ID string containing ID. Used when displaying warnings in case of errors in the input.
#' 
#' @return string which contains the populated template
generate_display <- function(template, display_variables, ID){
  # Check if appropriate variables were past for a template
  
  # Need to fix code bellow to allow extraction of variables when md formatting is passed
  
  # template_variables <- extract_variables(template)
  # # Flag for missing variables
  # missing_variable_detected <- FALSE
  # for (single_variable in template_variables) {
  #   if(!(single_variable %in% names(display_variables))){
  #     missing_variable_detected <- TRUE
  #     warning(glue::glue('Template variable {single_variable} is missing from the passed display_variables list.\n'))
  #   }
  # }
  # if(missing_variable_detected){
  #   stop()
  # }
  
  # Verify display inputs
  for (column_name in names(display_variables)) {
    verify_input(display_variables[[column_name]], missing_warning(column_name, ID))
  }
  
  element_display <- glue::glue(template, .envir = display_variables)
  
  return(element_display)
}

#' Extract variables in template
#' 
#' Extracts variables used in a template string
#' 
#' @param template string to check for variables
#' 
#' @return vector of strings
extract_variables <- function(template){
  variable_pattern <- "\\{(.*?)\\}"
  
  all_detected_vars <- unique(regmatches(template, gregexpr(variable_pattern, template))[[1]])
  
  template_variables <- c()
  # Strip brackets for easier comparison
  for (detected_variable in all_detected_vars) {
    detected_variable <- gsub('\\{|\\}', '', detected_variable)
    template_variables <- append(template_variables, detected_variable)
  }
  
  return(template_variables)
}

#' Bullet point template population
#' 
#' Populates the bullet point template with preset inputs
#' 
#' @param part_info data.table containing raw parts information
#' @param partID string containing the ID
#' @param part_bullet_template string containing display template
#' 
#' @return glue object string populated using part_info
bullet_point_template_population <- function(part_info, partID, part_bullet_template){
  # Declare display elements
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