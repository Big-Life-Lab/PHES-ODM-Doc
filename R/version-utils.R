source("R/constants.R")
#' Get latest version
#'
#' Get the latest version from vector of file names
#'
#' @param file_names string or string vector containing file names with valid semantic versioning
#'
#' @return vector of strings containing latest version and latest version file name
get_latest_version <- function(file_names) {
  dictionary_version_pattern <- "ODM_dictionary_(.*?).xlsx"
  
  # Display warning for multiple dictionaries as only 1 should be stored on github
  if (length(file_names) > 1) {
    warning('Multiple dictionaries found only one dictionary should be stored.')
  }
  
  
  version_numbers <- c()
  
  for (file_name in file_names) {
    version_number <-
      regmatches(file_name,
                 regexec(dictionary_version_pattern, file_name))[[1]][2]
    version_numbers <- append(version_numbers, version_number)
  }
  
  parsed_versions <- semver::parse_version(version_numbers)
  
  latest_version <- max(parsed_versions)
  
  # convert the svptr class into string
  latest_version <- as.character(latest_version)
  
  # Find the file name with the latest version
  latest_version_file_name <-
    file_names[[latest_version %in% version_numbers]]
  
  return(c(latest_version, latest_version_file_name))
  
}
