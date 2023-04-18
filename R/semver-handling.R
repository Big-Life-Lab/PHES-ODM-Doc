# Accepts list of returns of convert_to_semver? Or should I handle the conversion within?
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
      if(length(max_version)<1){
        max_version <- list(version_number)
      }else{
        max_version_subset <- as.numeric(max_version[[1]][[version_element_index]])
        current_version_subset <- as.numeric(version_number[[version_element_index]])
        if(current_version_subset > max_version_subset){
          # reset list
          max_version <- list(version_number)
        }else if(current_version_subset == max_version_subset){
          # Append if only one other element exists
          max_version[[length(max_version)+1]] <- version_number
        }
      }
    }
    if (length(max_version) <= 1) {
      break
    }else if(version_element_index>=6){
      # Reached limit of list indexes for a semver object
      # Issue error or warning
      break
    }else{
      version_element_index <- version_element_index + 1
      # Reduce the versions to check to only contain current maxes
      versions_list <- max_version
      max_version <- list()
    }
  }
  
  return(max_version)
}

convert_to_semver <- function(version_string) {
  version_extraction_regex <-
    '(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?'
  
  # The regex always returns original string and 5 groups
  # The below command returns a list with 1 element inside the element is a vector of 6 characters
  # The first character is original string
  # Elements 2-4 are the Major, Minor, and Path digits
  # Element 5 is <pre-release> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  # Element 6 is <build> information according to https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions
  formated_version <- regmatches(version_string,
                                 regexec(version_extraction_regex, version_string))[[1]][1:5]
  return(formated_version)
}