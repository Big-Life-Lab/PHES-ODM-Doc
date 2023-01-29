# Utility functions and code for working with PHES-ODM files on OSF.io

library(here)
library(osfr)
library(dplyr)
library(readxl)
source(file.path(here(), "R/version_utils.R"))

# OSF.io project information for the PHES-ODM.
osf_project_url <- 'https://osf.io/49z2b/'
osf_project <- '49z2b'

# OSF.io private files require access with a personal access token.
# See https://docs.ropensci.org/osfr/articles/auth.html

# get the OSF project information
odm_osf <- osf_retrieve_node(osf_project)

raw_data_folder <- file.path(here(),'data/raw')
table_data_folder <- file.path(here(), 'data/tables')
dictionary_tables <- c('parts', 'sets', 'languages', 'translations') 
odm_file_types <- c('dev_dictionary', 'dictionary', 'templates', 'lists-planes') # add more file types here as needed.

ODM_file_name <- "ODM_dev-dictionary_2.0.0-rc.1.xlxs"

ODM_file_name_parts(ODM_file_name)

# need to fix partID = protocolRelationshipsOrder, qualityReportRequired , protocolRelationshipRequiredin Dictionary_RC.xlsx
# Columns `protocolRelationshipOrder`, `protocolRelationshipRequired`, and `qualityReportRequired` don't exist.
# --- now fixed in the working copy of the dictionary ----

components <- osf_ls_nodes(odm_osf)  # get OSF.io components, ODM versions, files
reference_folder <- filter(components, grepl('^Reference', name)) # get the 'Reference files' component -- where the reference files are stored.
reference_version_folders <- osf_ls_files(reference_folder) # within reference_folder, get a list of all the folders. There is a folder for each ODM version.

####### Working with the "working copy" of the Excel dictionary ######
# The working copies of the ODM Excel dictionaries are the Working Copy component. 
# i.e. Working Copy/Excel dictionaries/ODM_dev-dictionary_2.0.0-rc.3.xlxs

# get the component "Working Copies" and an object with a list of the 
# different versions of the Excel dictionaries
working_copy <- filter(components, grepl('^Working', name))
excel_dictionaries <- osf_ls_files(working_copy, path = "Excel dictionaries")
new_dictionary <- osf_ls_files(working_copy, path = "new version here")

# get the newest dictionary


# # order by ODM dictionaries by version number
# excel_dictionaries <- excel_dictionaries[order(excel_dictionaries$name), ]
# excel_dictionary_names <- excel_dictionaries[c('name')]
# latest_dev_dictionary <- tail(excel_dictionaries, n=1)
# 
# # get the last working dictionary (the last dictionary in the ordered list)
# dev_dictionary <- osf_retrieve_file(as.character(latest_dev_dictionary['id']))
# dev_dictionary <- osf_download(latest_dev_dictionary, path = raw_data_folder, conflicts = "overwrite")



####### Working with reference files ######

# order by ODM version containers by version number
reference_version_folders <- reference_version_folders[order(reference_version_folders$name), ]
version_names <- reference_version_folders[c('name')]

# check to see 

# use the last version, or change the default version
default_version <- tail(reference_version_folders, n=1)
default_version_name <- tail(version_names, n=1)

# Working to here

# default_version <- "Version 2.0 Release Candidate 2 - Dictionary & Templates"
files <- osf_ls_files(default_version)
file_names <- files[c('name')]

# The dictionary object has the folder path for the dictionary.
dev_dictionary_path <- as.character(dictionary['local_path']) 

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

# generate an Excel dictionary from the development version.
# ODM_dev-dictionary-{version}.xlxs --> ODM_dictionary-.xlxs
# the public use dictionary excludes temporary tabs.



#version_list <- c("1.2.3", "4.1.0", "5.5.0", "3.2.0-beta.1", "3.10.1")


