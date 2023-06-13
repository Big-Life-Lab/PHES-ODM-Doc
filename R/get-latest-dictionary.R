source("R/odm-dictionary-file.R")
source("R/semver-handling.R")
#' Get latest version
#'
#' Get the latest dictionary version
#'
#' @param load_sheets boolean toggle to load commonly used sheets
#'
#' @return list containing latest version, latest dictionary file name, and commonly used sheets
get_latest_dictionary <- function(load_sheets = TRUE) {
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
  parts_sheet <- FALSE
  sets_sheet <- FALSE
  if(load_sheets) {
    parts_sheet <-
      readxl::read_excel(
        file.path(
          getwd(),
          odm_dictionary$dictionary_directory,
          latest_version_file_name
        ),
        sheet = odm_dictionary$parts_sheet_name
      )
    sets_sheet <- readxl::read_excel(
      file.path(
        getwd(),
        odm_dictionary$dictionary_directory,
        latest_version_file_name
      ),
      sheet = odm_dictionary$sets_sheet_name
    )
  }
  
  return(list(
	version = latest_version, 
	file_name = latest_version_file_name, 
	dictionary = list(
		parts = parts_sheet, 
		sets = sets_sheet
	)
  ))
}
