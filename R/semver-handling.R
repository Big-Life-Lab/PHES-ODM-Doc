#' Get max version
#'
#' Extract max version from vector of version strings.
#'
#' @param version_strings vector of string containing version string.
#'
#' @return string representing the max version found
get_max_version <- function(versions_strings) {
  versions_list <- list()
  for (version_index in seq_len(length(versions_strings))) {
    versions_list[[version_index]] <-
      convert_to_semver(versions_strings[[version_index]])
  }
  # R does not appear to contain a do while and this is the suggested approach
  version_element_index <- 2
  max_version <- list()
  repeat {
    # Can't use version variable name due to it being a base R function
    for (version_number in versions_list) {
      if (length(max_version) < 1) {
        max_version <- list(version_number)
      } else{
        max_version_subset <-
          as.numeric(max_version[[1]][[version_element_index]])
        current_version_subset <-
          as.numeric(version_number[[version_element_index]])
        # Empty values equate to later version
        if (is.na(current_version_subset) ||
            current_version_subset > max_version_subset) {
          # reset list
          max_version <- list(version_number)
        } else if (current_version_subset == max_version_subset) {
          # Append if only one other element exists
          max_version[[length(max_version) + 1]] <- version_number
        }
      }
    }
    if (length(max_version) <= 1) {
      break
    } else{
      version_element_index <- version_element_index + 1
      # Reduce the versions to check to only contain current maxes
      versions_list <- max_version
      max_version <- list()
    }
  }
  
  # Return the original full version string
  return(max_version[[1]][[1]])
}

#' Convert to semver
#'
#' Utility function to break apart a version string into a version list.
#' With further conversion of alphanumeric pre-release info into numeric list.
#'
#' @param version_string string representing the version as one full string.
#'
#' @return list containing the version split into seperate elements.
convert_to_semver <- function(version_string) {
  # Regex contains slightly modified official semver regex found here: https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
  # The modifications involve required new line and start of string.
  semver_regex <-
    '(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?'
  
  supported_pre_releases <- c("alpha", "beta", "rc")
  # The regex always returns original string and 5 groups
  # The below command returns a list with 1 element inside the element is a vector of 6 characters
  # The first character is original string
  # Elements 2-4 are the Major, Minor, and Path digits
  # Element 5 is <pre-release> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  # Element 6 is <build> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  formated_version <- regmatches(version_string,
                                 regexec(semver_regex, version_string))[[1]][1:5]
  
  # Split semantic pre-release info
  pre_release <- formated_version[[5]]
  if (pre_release != "") {
    pre_release_info <- strsplit(pre_release, "\\.")
    pre_release_name <- pre_release_info[[1]][[1]]
    
    # Supporting only 3 version numbers with pre_release tag
    if (length(pre_release_info[[1]]) > 4) {
      stop(
        glue::glue(
          'Only 3 version numbers are allowed after a pre-release tag, {version_string} contains more.'
        )
      )
    }
    # Loop over remaining pre_release info
    for (pre_release_index in 2:seq_len(length(supported_pre_releases))) {
      current_pre_release_info <-
        pre_release_info[[1]][[pre_release_index]]
      # Supporting only 1 pre_release tag
      if (is.na(as.numeric(current_pre_release_info))) {
        stop(
          glue::glue(
            'A second pre_release tag was found in {version_string}, only one version tag is allowed.'
          )
        )
      }
      
    }
    
    is_supported_tag <- FALSE
    for (supported_pre_release_index in seq_len(length(supported_pre_releases))) {
      if (pre_release_name == supported_pre_releases[[supported_pre_release_index]]) {
        is_supported_tag <- TRUE
      }
    }
    # Handle no valid match
    if (!is_supported_tag) {
      stop(glue::glue(
        'Invalid pre-release tag found {pre_release_name}, only alpha, beta, rc are supported at the moment'
      ))
    }
    # Append info as further basic versioning
    # Removing the 5th element as its been converted
    formated_version <-
      append(formated_version[-5], pre_release_info[[1]])
  }
  
  return(formated_version)
}