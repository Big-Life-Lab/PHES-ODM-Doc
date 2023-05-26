# Storing supported pre-release tags
supported_pre_releases <- c("alpha", "beta", "rc")
#' Get max version
#'
#' Extract max version from vector of version strings.
#'
#' @param version_strings vector of string containing version string.
#'
#' @return string representing the max version found
get_max_version <- function(version_strings) {
  parsed_semvers <- list()
  for(version_string in version_strings) {
    parsed_semver <- convert_to_semver(version_string)
    parsed_semvers[[length(parsed_semvers)+1]] <- parsed_semver
  }
  
  max_version_index <- NA
  for(parsed_semver_index in 1:length(parsed_semvers)) {
    if(is.na(max_version_index)) {
      max_version_index <- parsed_semver_index
    }
    else if(greater_than_version(
      parsed_semvers[[parsed_semver_index]], 
			parsed_semvers[[max_version_index]])
		) {
      max_version_index <- parsed_semver_index
    }
  }

  # Return the original full version string
  return(version_strings[max_version_index])
}

#' Convert to semver
#'
#' Utility function to break apart a version string into a version list.
#' With further conversion of alphanumeric pre-release info into numeric list.
#'
#' @param version_string string representing the version as one full string.
#'
#' @return named list containg the initial string split into: major, minor, patch, pre_release_type, pre_release_version.
convert_to_semver <- function(version_string) {
  # Regex contains slightly modified official semver regex found here: https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
  # The modifications involve required new line and start of string.
  semver_regex <-
    '(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?'
  
  # The regex always returns original string and 5 groups
  # The below command returns a list with 1 element inside the element is a vector of 6 characters
  # The first character is original string
  # Elements 2-4 are the Major, Minor, and Path digits
  # Element 5 is <pre-release> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  # Element 6 is <build> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  formatted_version <- regmatches(
    version_string,
    regexec(semver_regex, version_string)
  )[[1]][1:5]
  
  # Split semantic pre-release info
  pre_release_type <- NA
  pre_release_version <- NA
  pre_release_string <- formatted_version[[5]]
  if (pre_release_string != "") {
    pre_release_info <- strsplit(pre_release_string, "\\.")

    pre_release_type <- pre_release_info[[1]][1]
    if(pre_release_type %in% supported_pre_releases == FALSE) {
      stop(paste(
        "Unsuppored pre-release version detected. Supported version are",
	paste(supported_pre_releases, collapse = ",")
      ))
    }
    
    # If the user passes in a decimal after the pre-release tag (for eg, 3.9)
    # it will get split into "3" and "9"
    # We need to collect and reform the string 3.9, and convert it to a
    # numeric
    pre_release_version <- as.numeric(
      paste(
        pre_release_info[[1]][2:length(pre_release_info[[1]])], 
	collapse="."
      )
    )
    if(is.na(pre_release_version)) {
      stop(paste(
        "Missing version number for pre-release"
      ))
    }
  }
  
  return(list(
    major = as.numeric(formatted_version[[2]]),
    minor = as.numeric(formatted_version[[3]]),
    patch = as.numeric(formatted_version[[4]]),
    pre_release_type = pre_release_type,
    pre_release_version = pre_release_version
  ))
}

greater_than_version <- function(left_version, right_version) {
  if(left_version$major > right_version$major) {
    return(TRUE)
  }

  if(left_version$minor > right_version$minor) {
    return(TRUE)
  }
  
  if(left_version$patch > right_version$patch) {
    return(TRUE)
  }
  
  if(is.na(left_version$pre_release_type) & 
     !is.na(right_version$pre_release_type)) {
    return(TRUE)
  }
  if(!is.na(left_version$pre_release_type) &
     !is.na(right_version$pre_release_type)) {
    left_pre_release_priority <- which(
      supported_pre_releases == left_version$pre_release_type
    )
    right_pre_release_priority <- which(
      supported_pre_releases == right_version$pre_release_type
    )
    if(left_pre_release_priority > right_pre_release_priority) {
      return(TRUE)
    }

    if(left_version$pre_release_version > right_version$pre_release_version) {
      return(TRUE)
    }
  }

  return(FALSE)
}
