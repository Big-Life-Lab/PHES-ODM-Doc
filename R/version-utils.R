#' Get latest version
#' 
#' Get the latest version from vector of file names
#' 
#' @param file_names string or string vector containing file names with valid semantic versioning
#' 
#' @return semver object containing the latest version
get_latest_version <- function(file_names) {
  
  # Cant extract without knowing file name will await clarification
  # files_info_source <-
  #   readxl::read_excel(file.path(getwd(),constants$dictionary_directory, dictionary_full_file_name),
  #                      sheet = "files")
  
  # Will attempt to extract from file if possible
  dictionary_version_pattern <- "ODM_dictionary_(.*?).xlsx"
  version_numbers <- c()
  
  for (file_name in file_names) {
    version_number <-
      regmatches(
        file_name,
        regexec(dictionary_version_pattern, file_name)
      )[[1]][2]
    version_numbers <- append(version_numbers, version_number)
  }
  
  formated_versions <- semver::parse_version(version_numbers)
  
  latest_version <- max(formated_versions)
  
}


