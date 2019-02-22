# compare_thresholds.R
# Evaluating use of different thresholds in mito localization analysis

# Question: when measuring mito localization, should we use a single mito threshold offset for all cells, or "best" for each cell?

# -- split dataset by threshold
# -- split dataset by cells
# -- evaluate the accuracy of the threshold:
#   -- mito volume, intensity, ???
#   -- how do these parameters vary within a single cell measured with different thresholds? how can we use this to determine the best" per cell?
#   -- which is more "reliable" (consistent, tighter, gives more realistic #s?)

# REQUIRES a dataframe 
# ---- Setup

require(tidyverse) # for reading and parsing
require(tcltk) # for file choosing


# ---- Load data



