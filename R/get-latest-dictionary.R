source("R/odm-dictionary-file.R")
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
    list.files(file.path(getwd(), odm_dictionary$dictionary_directory),
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
    file_names[which(version_numbers == latest_version)]
  
  parts_sheet <- readxl::read_excel(file.path(getwd(),odm_dictionary$dictionary_directory, latest_version_file_name),
                     sheet = odm_dictionary$parts_sheet_name, .name_repair = "unique_quiet")
  sets_sheet <- readxl::read_excel(
    file.path(
      getwd(),
      odm_dictionary$dictionary_directory,
      latest_version_file_name
    ),
    sheet = odm_dictionary$sets_sheet_name,
    # Parse all columns as text so that even if a column has only numbers in it
    # we can insert NA string values into it. If we do not do this then tidyr
    # will complain and stop execution.
    col_types = "text",
    .name_repair = "unique_quiet"
  )
  
  return(list(
	version = latest_version, 
	file_name = latest_version_file_name, 
	dictionary = list(
		parts = parts_sheet, 
		sets = sets_sheet
	)
  ))
}
