# version_utils.R
# Utilities to work with semantic versioning

library(semver)

####### is the string a valid version?
semantic_version_check <- function(version) {
  semver_pattern <- "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$"
  if (grepl(semver_pattern, version)) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# check a list to see if all elements are valid version names
check_semantic_versions <- function(version_list) {
  if (!(is.character(version_list))) {
    return("version_list is not a character list")
  } else {
    for (version in version_list) {
      if (!semantic_version_check(version)) { 
        return(FALSE)
      }
    }
    return(TRUE)
  }
}

# find the most up-to-date version
find_highest_version <- function(version_list) {
  #check if `semver` is installed 
  if (!("semver" %in% rownames(installed.packages()))) {
    # If the library is not installed, install it
    install.packages("semver")
    library("semver")
  }
  
  if (!check_semantic_versions(version_list)) {
    return("version_list is not a valid list of versions.")
  } else {}
  local({
    versions_ranked <- rank(semver::parse_version(version_list))
    versions_highest <- which.max(versions_ranked)
    return(versions[versions_highest])
  })
}

ODM_file_name_parts <- function(ODM_file_name = ODM_file_name, versioning = TRUE) {
  # Check whether a file is a valid ODM file name
  # If valid, return a list of the four sections of the name
  # e.g. ODM-file-2.0.0.xlsx to ('ODM', 'file', '2.0.0', 'xlsx')

    # First, generates a list of the three elements separated by '_'
    split_file <- strsplit(ODM_file_name, "_")[[1]]
    
    # Separate the last element into the version and the extension.
    last_element <- tail(split_file, 1)
    extension <- tools::file_ext(last_element)
    version_ODM <- tools::file_path_sans_ext(last_element)
    
    # ODM file name begin with 'ODM
    if (!head(split_file, 1) =='ODM') {
      warning(paste0("Warning: ODM file names begin with 'ODM'. The current file name begins with '", head(split_file, 1), "'."))
    }
    
    # If versioning = TRUE, the element before the extension must be a valid semanatic version
    if (check_semantic_versions(version_ODM) == FALSE) {
      warning(paste0("Warning: File name does not contain a valid semantic version. Instead, version element is '", version_ODM, "'."))
    }
    # return the list
    return (c(head(split_file,2), version_ODM, extension))

}
