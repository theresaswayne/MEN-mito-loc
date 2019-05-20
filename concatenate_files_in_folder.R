# concatenate_files_in_folder.R


# adapted from http://serialmentor.com/blog/2016/6/13/reading-and-combining-many-tidy-data-files-in-R

# Setup -------
require(tidyverse) # for reading and parsing
require(tcltk) # for file choosing


# Get data files ----

# Note -- you must OPEN the folder!

inputFolder <- tk_choose.dir(default = "", caption = "OPEN the folder with the files you want to combine") # prompt user

# get file names
files <- dir(inputFolder, pattern = "*.csv") 

# read into a tibble 
# (data_frame is deprecated)
# in the list, column 1 = file names, column 2 = data

mergedDataWithNames <- tibble(filename = files) %>% 
  mutate(file_contents =
           map(filename,          
               ~ read_csv(file.path(inputFolder, .),
                          locale = locale(encoding = "latin1"),
                          na = c("", "N/A", "NA"))))

# TODO: default all columns to double? (then have to specify any non-double columns)


# make the list into a flat file
mergedDataFlat <- unnest(mergedDataWithNames)


# Save merged data----------

# saves the data one level up 
parentName <- basename(inputFolder) # parent directory without higher levels
parentDir <- dirname(inputFolder)

outputFile = paste(Sys.Date(), parentName, "merged.csv") # spaces will be inserted
write_csv(mergedDataFlat,file.path(parentDir, outputFile))

