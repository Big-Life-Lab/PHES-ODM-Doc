# Utility functions and code for working with PHES-ODM files on OSF.io

library(here)
library(osfr)
library(dplyr)
library(readxl)


osf_project_url <- 'https://osf.io/49z2b/'
osf_project <- '49z2b'

# get the OSF project information
odm_osf <- osf_retrieve_node(osf_project)

raw_data_folder <- file.path(here(),'data/raw')
table_data_folder <- file.path(here(), 'data/tables')
dictionary_tables <- c('parts', 'sets', 'languages', 'translations')

# need to fix partID = protocolRelationshipsOrder, qualityReportRequired , protocolRelationshipRequiredin Dictionary_RC.xlsx
# Columns `protocolRelationshipOrder`, `protocolRelationshipRequired`, and `qualityReportRequired` don't exist.

# get OSF.io components, ODM versions, files
components <- osf_ls_nodes(odm_osf)
versions <- filter(components, grepl('^Version', name))

# order by ODM version number
versions <- versions[order(versions$name), ]
version_names <- versions[c('name')]

# use the last version, or change the default version
default_version <- tail(versions, n=1)
default_version_name <- tail(version_names, n=1)
# default_version <- "Version 2.0 Release Candidate 2 - Dictionary & Templates"
files <- osf_ls_files(default_version)
file_names <- files[c('name')]

#download and save the Excel dictionary and templates in ../data/raw
dictionary <- filter(files, grepl('^Dict', name))
dictionary <- osf_retrieve_file(as.character(dictionary['id']))
dictionary <- osf_download(dictionary, path = raw_data_folder, conflicts = "overwrite")

# The dictionary object has the folder path for the dictionary.
dictionary_path <- as.character(dictionary['local_path']) 

templates <- filter(files, grepl('^Templates', name))
templates <- osf_retrieve_file(as.character(templates['id']))
templates <- osf_download(templates, path = raw_data_folder, conflicts = "overwrite")

# generate and save the dictionary table CSV files
for (item in dictionary_tables) {
  print(item)
  table <- read_excel(dictionary_path, sheet = item)
  if (item == 'parts') {
    parts <- table
  }
  
  # get list of table headers
  # select  dictionary table headers using `eval(parse(text = item)`
  headers <-  filter(parts, (eval(parse(text = item)) %in% c('header', 'pK', 'fK')))
  headers_list <- as.character(headers$partID)
  table <- select(table, any_of(headers_list))
  
  # write tables as csv files.
  table_name <- paste(item, "csv", sep = ".")
   write.csv(table, file.path(table_data_folder, table_name))
}

get_partType <- function(df = parts, partType) {
   return (filter(df, partType == "table"))
}




