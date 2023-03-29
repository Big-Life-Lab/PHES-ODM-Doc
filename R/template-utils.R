#' Generate display string
#' 
#' Populates passed template with values from display_variables after verifying.
#' 
#' @param template string template containg variables to insert surrounded by {}
#' @param display_variables named list with values to insert where name is equal to name in template
#' @param ID string containing ID used in warning generation
#' 
#' @return string which contains the populated template
generate_display <- function(template, display_variables, ID){
  # Check if appropriate variables were past for a template
  detected_variables <- extract_variables(template)
  for (single_variable in detected_variables) {
    if(!(single_variable %in% names(display_variables))){
      stop(glue::glue('{single_variable} Is missing from the passed display'))
    }
  }
  
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
#' @return vector of variables used
extract_variables <- function(template){
  variable_patter <- "\\{(.*?)\\}"
  
  all_detected_vars <- unique(regmatches(template, gregexpr(variable_patter, template))[[1]])
  
  return_vars <- c()
  # Strip brackets for easier comparison
  for (detected_variable in all_detected_vars) {
    detected_variable <- gsub('\\{|\\}', '', detected_variable)
    return_vars <- append(return_vars, detected_variable)
  }
}

bullet_point_template_population <- function(part_info){
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