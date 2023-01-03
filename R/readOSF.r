# Automatically downloads and reads an OSF file
# from https://rdrr.io/github/SachaEpskamp/OSF2R/src/R/readOSF.R  

readOSF <- function(
    code, # Either "https://osf.io/XXXXX/" or just the code
    readfun, # Can be missing to be automatically detected
    ... # Arguments sent to the read function
){
  # Download file to temp dir:
  fileLocation <- getOSFfile(code, tempdir())
  
  # If readfun is missing, detect it:
  if (missing(readfun)){
    
    fileex <- regmatches(fileLocation,regexpr("(?<=\\.).{1,4}$", fileLocation, perl=TRUE))
    readfun <- switch(fileex,
                      xlsx = xlsx::read.xlsx, # Excel file
                      xls = gdata::read.xls, # Old excel file
                      csv = read.csv, # CSV
                      txt = read.table, # Normal table
                      sav = foreign::read.spss, # Read SPSS
                      dta = foreign::read.dta
    )
  }
  
  # Read data and return:
  return(readfun(fileLocation, ...))
}