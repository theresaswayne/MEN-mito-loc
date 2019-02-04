# read_volocity_file.R
# imports and simplifies a single csv file exported from Volocity 6.3


# Setup -------
require(readr)
require(here)
require(dplyr)


# ENTER FILENAME HERE ----------
# NOTE -- assumes everything is in a directory called "data" in the project home
subfolder <- "2019-01-03 measurements"
dataname <- "GTY029 25C 3 (cropped)_03_c45m-80.csv"



# Read a single results file ------------
#   locale prevents multibyte string error
#   na converts Volocity's "N/A" into R <NA>, 
#     and allows columns with NA's to be auto-read as numeric
raw_data <- read_csv(here("data", file.path(subfolder,dataname)),
              locale = locale(encoding = "latin1"),
              na = c("", "N/A"))




# Simplify -------

# There are several unnecessary rows and columns.
# Every Trans column is unnecessary
# Every Whole cells prelim is unnecessary

df <- filter(raw_data, Population != "Whole cells prelim") %>%
  select(-contains("Trans"))


# Note on column names --------

# There may be 37 or 38 variables depending on the dataset. Data exported directly from the "All Populations" view has an extra ID column that is basically just a row number. Not an object ID.
# The protocol as of 2019-01-03 produces 38 columns.
# 
# subfolder <- "2019-01-03 measurements"
# dataname <- "GTY029 25C 3 (cropped)_03_c45m-80.csv"
# 
# 
# c38_file <- read_csv(here("data", file.path(subfolder,dataname)),
#                      locale = locale(encoding = "latin1"),
#                      na = c("", "N/A"))
# 
# c37_file <- read_csv(here("data", "20181213 GTY029_25C_9-12_measurements_no_roi.csv"),
#                          locale = locale(encoding = "latin1"),
#                          na = c("", "N/A"))
# 
# c37names <- colnames(c37_file)
# # this starts with Name, Item Name
# 
# c38names <- colnames(c38_file)
# # this starts with ID, Item Name, Name -- the ID gives each row in the dataset a unique number




