# Function to download OSF file
# https://rdrr.io/github/SachaEpskamp/OSF2R/src/R/getOSFfile.R

library(rcurl)

getOSFfile <- function(
    code,  #Either "https://osf.io/XXXXX/" or just the code
    dir = getwd() # Output location
){
  
  # Check if input is code:
  if (!grepl("osf\\.io",code)){
    URL <- sprintf("https://osf.io/%s/",code)
  } else URL <- code
  
  # Scan page:
  Page <- RCurl::getURL(URL)
  
  # Extract download link(s):
  Link <- regmatches(Page, regexpr("(?<=download: \\').*?\\?action=download(?=\\')", Page, perl = TRUE))
  
  # Stop if no download link:
  if (length(Link)==0){
    stop("No download link found")
  }
  # (just in case) if more than one, warning:
  if (length(Link)>1){
    warning("Multiple download links found, only first is used")
    Link <- Link[1]
  }
  
  # Full link:
  Link <- paste0("https://osf.io/",Link)
  
  # Estract file name:
  FileName <- gsub("(^.*files/)|(\\/\\?action=download$)","",Link)
  FullPath <- paste0(dir,"/",FileName)
  
  # Download file (So far using sytem instead of RCurl):
  httr::GET(Link, httr::write_disk(FullPath, overwrite = TRUE))
  #   system(sprintf("curl -J -L %s > %s", Link, FullPath), ignore.stderr = TRUE)
  
  # Return location of file:
  return(FullPath)
}