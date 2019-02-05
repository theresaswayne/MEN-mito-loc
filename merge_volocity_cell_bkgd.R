# merge_volocity_cell_bkgd.R
# imports, merges, sorts, and simplifies a batch of csv files exported from Volocity 6.3 and a separate background spreadsheet csv
# Theresa Swayne, Columbia University, 2019

# REQUIREMENTS: 
# -- All cell data files must be within a single folder in the "data" folder in the project home
# -- The background file must be outside this folder and must have 2 columns, ItemName and ExtracellularBackground

# adapted from http://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R

# Setup -------
require(here)
require(tidyverse)

# TODO: update to allow user to select locations

# ENTER BACKGROUND FILE INFO HERE -----
subfolder_bkgd <- file.path("2019-02-04 HK", "2018.12.18 PSY109 at 25C and 36C deconvolved")
inputFolder_bkgd <- here(file.path("data",subfolder_bkgd))
bkgdfile <- "Extracellular Background GFP Channel PSY109.csv"

xcell_bg <- read_csv(file.path(inputFolder, bkgdfile),
                     locale = locale(encoding = "latin1"),
                     col_types = cols_only(ItemName = "c", ExtracellularBackground = "d"))

  # can safely ignore warning message about missing column names

# ENTER CELL FOLDER INFO HERE ----------

subfolder_cells <- file.path("2019-02-04 HK", "2018.12.18 PSY109 at 25C and 36C deconvolved", "PSY109 CSV")

# Read all the files in the folder ------

inputFolder_cells <- here(file.path("data",subfolder_cells))
outputFolder <- subfolder_bkgd 

# get file names
files <- dir(inputFolder, pattern = "*.csv") 

# tibble is used because of the warning that data_frame is deprecated.
mergedDataWithNames <- tibble(filename = files) %>% # tibble holding file names
  mutate(file_contents =
           map(filename,          # read files into a new data column
               ~ read_csv(file.path(inputFolder, .),
                          locale = locale(encoding = "latin1"),
                          na = c("", "N/A"),
                          col_types = cols(`Number of contained Mito` = col_double(),
                                           `Compartment ROIs ID` = col_double()))))

# unnest to make the list into a flat file again,
# but it now has 1 extra column to hold the filename
mergedDataFlat <- unnest(mergedDataWithNames)

# Simplify -------

df <- filter(mergedDataFlat, Population != "Whole cells prelim") %>% # unwanted objects
  select(-contains("Trans")) %>% # unwanted channels
  arrange(filename,ID)  # sort rows


# Write an output file of all the merged data ----------

outputFile = paste(subfolder_bkgd, Sys.Date(), "merged.csv") # spaces will be inserted
#write_csv(df,file.path(outputFolder, outputFile))
#TODO: read background here and merge it all at once

