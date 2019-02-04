# test_string_match.R
# testing retrieval of factors from filename text

require(tidyverse)

filename <- c("GTY029 25C 2 (cropped)_01_c10m-80.csv",
              "GTY029 25C 6 (cropped)_03_c50m-50.csv",
              "GTY029 25C 9 (cropped)_05_c40m200.csv")

verify <- c(-80, -50, 200) # ground truth

tbl <- cbind(filename, verify) %>% as_tibble()

# note R uses ICU-style regex, not compatible with regex101.com

myexp <- "m([:graph:]+)\\.csv" # any letter/number/punc characters between m and .csv

matched <- str_match(filename, myexp)

new_tbl <- mutate(tbl, thresh = matched[,2])

temp_exp <- "(\\d{2})C" # any 2 number characters before C
matched_temp <- str_match(filename, temp_exp)
