source("R/constants.R")
source("R/semver-handling.R")
#' Get latest version
#'
#' Get the latest version from vector of file names
#'
#' @param file_names string or string vector containing file names with valid semantic versioning
#'
#' @return vector of strings containing latest version and latest version file name
get_latest_dictionary <- function() {
  dictionary_version_pattern <- "ODM_dictionary_(\\d.*?).xlsx"
  file_names <-
    list.files(file.path(getwd(), constants$dictionary_directory),
               pattern = dictionary_version_pattern)
  # Display warning for multiple dictionaries as only 1 should be stored on github
  if (length(file_names) > 1) {
    warning('Multiple dictionaries found only one dictionary should be stored.')
  }else if(length(file_names)==0){
    stop("No valid files were detected. Make sure the dictionary file is named correctly.")
  }
  
  
  version_numbers <- c()
  
  for (file_name in file_names) {
    version_number <-
      regmatches(file_name,
                 regexec(dictionary_version_pattern, file_name))[[1]][2]
    version_numbers <- append(version_numbers, version_number)
  }
  
  
  latest_version <- get_max_version(version_numbers)
  
  # Find the file name with the latest version
  latest_version_file_name <-
    file_names[[latest_version %in% version_numbers]]
  
  parts_sheet <- readxl::read_excel(file.path(getwd(),constants$dictionary_directory, latest_version_file_name),
                     sheet = constants$parts_sheet_name)
  sets_sheet <- readxl::read_excel(
    file.path(
      getwd(),
      constants$dictionary_directory,
      latest_version_file_name
    ),
    sheet = constants$sets_sheet_name
  )
  
  return(list(latest_version, latest_version_file_name, parts_sheet, sets_sheet))
  
}
