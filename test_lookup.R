# test_lookup.R
# for testing how to include a new column based on a different dataframe
# this is called a "mutating join"

# https://dplyr.tidyverse.org/articles/two-table.html

require(dplyr)

IDs <- c(1,2,5,6,12)
ID2s <- c(1,2,5,5,6,12)
val1s <- c("val1-1","val1-2","val1-5","val1-6","val1-12")
val2s <- c("val2-1","val2-2","val2-5a","val2-5b","val2-6","val2-12")

tbl1 <- cbind(IDs = IDs,val1s) %>% as_tibble() # tbl is required for join function
tbl2 <- cbind(IDs = ID2s,val2s) %>% as_tibble() 

tbl3 <- tbl2 %>% left_join(tbl1) # merges the tables by the common variable (ID)

