tmp_downloads <- "data/tmp"
valid_file_types <- c("csv", "excel")

create_release_files <- function(OSF_LINK, OSF_TOKEN) {
  # Download file using passed credentials
  osfr::osf_auth(OSF_TOKEN)
  osfr::osf_retrieve_file(OSF_LINK) %>%
    osfr::osf_download(path = tmp_downloads)
  
  # Validate dictionary version
  dictionary_info <- validate_version()
  
  # Validate files sheet
  tmp <-
    validate_files_sheet(dictionary_info$dictionary_name,
                         dictionary_info$dictionary_version)
  return(tmp)
}
validate_version <- function() {
  # Acquire version number from file name
  dictionary_version_pattern <- "ODM_dictionary_(\\d.*?).xlsx"
  file_names <-
    list.files(file.path(getwd(), tmp_downloads),
               pattern = dictionary_version_pattern)
  # Display error and stop execution for multiple dictionaries
  if (length(file_names) > 1) {
    stop('Multiple dictionaries found, only one dictionary should be stored.')
  } else if (length(file_names) == 0) {
    stop("No valid files were detected. Make sure the dictionary file is named correctly.")
  }
  dictionary_file_name_version_number <-
    regmatches(file_names,
               regexec(dictionary_version_pattern, file_names))[[1]][2]
  
  # Acquire version number from summary sheet
  summary_sheet <- readxl::read_excel(file.path(getwd(),
                                                tmp_downloads,
                                                file_names),
                                      sheet = "summary")
  # Read the first column
  summary_versions <- summary_sheet[[1]]
  # Strip off any NA rows
  summary_versions <- summary_versions[!is.na(summary_versions)]
  # Select the last version
  summary_version <- summary_versions[[length(summary_versions)]]
  matching_versions <- FALSE
  # Compare if the versions match
  if (summary_version == dictionary_file_name_version_number) {
    matching_versions <- TRUE
  }
  
  #ASK YULRIC IF THIS IS OKAY
  return(
    list(
      dictionary_name = file_names,
      dictionary_version = summary_version,
      matching_versions = matching_versions
    )
  )
}
validate_files_sheet <- function(dictionary_name, version) {
  files_sheet <- readxl::read_excel(file.path(getwd(),
                                              tmp_downloads,
                                              dictionary_name),
                                    sheet = "filesV2")
  sets_sheet <- readxl::read_excel(file.path(getwd(),
                                             tmp_downloads,
                                             dictionary_name),
                                   sheet = "sets")
  
  # Check with YULRIC
  # Remove any rows where name is na
  files_sheet_formatted <-
    files_sheet[files_sheet$fileType %in% valid_file_types, c(
      "fileID",
      "name",
      "fileType",
      "partID",
      "addHeaders",
      "destinations",
      "osfLocation",
      "githubLocation"
    )]
  # isert version
  files_sheet_formatted$name <-
    gsub('\\{version\\}', version, files_sheet_formatted$name)
  csv_to_extract <- c()
  excel_to_extract <- list()
  errors <- ""
  for (row_index in 1:nrow(files_sheet_formatted)) {
    working_row <- files_sheet_formatted[row_index, ]
    partID <- working_row[["partID"]]
    fileType <- working_row[["fileType"]]
    if (fileType == "csv") {
      sets_info <- sets_sheet[sets_sheet$setID == partID, "partID"]
      if (nrow(sets_info) >= 1) {
        # Append error
        errors <-
          paste0(errors,
                 " \n",
                 partID,
                 " is recorded for csv but is found in sets.")
      } else{
        csv_to_extract <- c(csv_to_extract, partID)
      }
    } else if (fileType == "excel") {
      sets_info <- sets_sheet[sets_sheet$setID == partID, "partID"]
      if (nrow(sets_info) >= 1) {
        excel_to_extract[[partID]] <- sets_info
      } else{
        # Append error
        errors <-
          paste0(errors,
                 " \n",
                 partID,
                 " is recorded for excel but is not found in sets.")
      }
    }
  }
  if (errors != "") {
    warning(errors)
  }
  return(list(csv = csv_to_extract, excel = excel_to_extract))
}