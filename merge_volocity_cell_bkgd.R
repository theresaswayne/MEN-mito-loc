# merge_volocity_cell_bkgd.R
# imports, merges, sorts, and simplifies a batch of csv files exported from Volocity 6.3 and a separate background spreadsheet csv
# Theresa Swayne, Columbia University, 2019

# REQUIREMENTS: 
# -- All cell data files must be within a single folder in the "data" folder in the project home
# -- The background file must be one level above the cell data folder 
# -- Background file must have 2 columns: 
#     ItemName
#     ExtracellularBackground

# adapted from http://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R

# Setup -------
require(here)
require(tidyverse)
require(tcltk)

# Get background data -----

bkgdfile <- tk_choose.files(default = "", caption = "Choose the CSV with background values", multi = FALSE) # file chooser window, with a message

xcell_bg <- read_csv(bkgdfile,
                     locale = locale(encoding = "latin1"),
                     col_types = cols_only(
                       ItemName = "c", 
                       ExtracellularBackground = "d")) %>%
  select(ItemName, ExtracellularBackground)

  # can safely ignore warning message about missing column names

names(xcell_bg)[names(xcell_bg)=="ItemName"] <- "Item Name" # change column name to match the Volocity file column

# Get cell data ----


# Note -- you must OPEN the folder!

inputFolder_cells <- tk_choose.dir(default = "", caption = "OPEN the folder with cell data files") # prompt user

# get file names
files <- dir(inputFolder_cells, pattern = "*.csv") 

# read into a tibble 
# (data_frame is deprecated)

mergedDataWithNames <- tibble(filename = files) %>% # column 1 = file names
  mutate(file_contents =
           map(filename,          # column 2 = data
               ~ read_csv(file.path(inputFolder_cells, .),
                          locale = locale(encoding = "latin1"),
                          na = c("", "N/A"),
                          col_types = cols(`Number of contained Mito` = col_double(),
                                           `Compartment ROIs ID` = col_double()))))

# TODO: default all columns to double? (then have to specify any non-double columns)


# make the list into a flat file
mergedDataFlat <- unnest(mergedDataWithNames)

# Simplify -------

df <- filter(mergedDataFlat, Population != "Whole cells prelim") %>%  # remove unwanted objects
  select(-contains("Trans")) %>% # remove unwanted channels
  arrange(filename,ID)  # sort rows

# Merge with background data ----

df <- df %>% left_join(xcell_bg) # only common column is ItemName


# Save merged data one level up ----------

parentName <- basename(dirname(bkgdfile)) # parent directory without higher levels

parentDir <- dirname(bkgdfile)

outputFile = paste(Sys.Date(), parentName, "merged.csv") # spaces will be inserted
write_csv(df,file.path(parentDir, outputFile))

