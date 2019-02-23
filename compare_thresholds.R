# compare_thresholds.R
# Evaluating use of different thresholds in mito localization analysis

# Question: when measuring mito localization, should we use a single mito threshold offset for all cells, or "best" for each cell?

# -- split dataset by threshold
# -- split dataset by cells
# -- evaluate the accuracy of the threshold:
#   -- mito volume, intensity, ???
#   -- how do these parameters vary within a single cell measured with different thresholds? how can we use this to determine the best" per cell?
#   -- which is more "reliable" (consistent, tighter, gives more realistic #s?)

# REQUIRES a "mito_loc" csv saved by MEN_analysis_from_merged_data.R 
# which contains background-corrected mito and cell intensities

# Setup ----

require(tidyverse) # for reading and parsing
require(tcltk) # for file choosing
require(ggplot2) # for plots
require(RColorBrewer) # for plot palettes



# Load data ----

df_file <- tk_choose.files(default = "",
                           caption = "Select the CSV with summarized cell and mito values",
                           multi = FALSE) # file chooser window

df <- read_csv(df_file,
               col_types = cols(.default = "d",
                                filename = "c",
                                `ItemName` = "c"))


# Compare values obtained for each cell from different thresholds ---- 

# For this we need a new column, cell name 
# (this is filename minus the last 6 characters)
# TODO: add this to the mito loc script

df <- df %>% mutate(CellName = str_sub(filename, end = -10))

# Mito volume ---

# qual palette gives 3 different colors
# as.factor treats the thresh values as discrete

mv <- ggplot(df, aes(x = df$MitoVolume_um3, y = df$CellName, colour = as.factor(df$MitoThresh))) +
  geom_point(alpha = 0.8, size = 1) +
  scale_color_brewer(type = "qual", palette = 1, direction = 1, aesthetics = "colour") +
                       labs(title = "Mito volume in all cells by threshold") +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y.left = element_blank(),
        panel.grid = element_blank()) # suppress tick labels and gridlines

print(mv)

# Mito vol relative to "cell" volume ---
fmv <- ggplot(df, aes(x = df$MitoVolume_um3/df$CellVolume_um3, y = df$CellName, colour = as.factor(df$MitoThresh))) +
  geom_point(alpha = 0.8, size = 1) +
  scale_color_brewer(type = "qual", palette = 1, direction = 1, aesthetics = "colour") +
  labs(title = "Mito volume/Cell volume by threshold") +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y.left = element_blank(),
        panel.grid = element_blank()) # suppress tick labels and gridlines

print(fmv)

# Mito mean ---
mm <- ggplot(df, aes(x = df$MitoMeanCorr, y = df$CellName, colour = as.factor(df$MitoThresh))) +
  geom_point(alpha = 0.8, size = 1) +
  scale_color_brewer(type = "qual", palette = 1, direction = 1, aesthetics = "colour") +
  labs(title = "Mito mean by threshold") +
  theme_bw() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y.left = element_blank(),
        panel.grid = element_blank()) # suppress tick labels and gridlines

print(mm)

# observations for GTY 027 testdata
# mito mean is quite variable from cell to cell in the testdata but it is pretty consistent within a cell, across thresholds.
# mito volume / "cell" volume is the "tightest" measure across all cells
# it generally doesn't look like mv/cv varies more than 1.5 foldish, but a few cells have quite divergent values. 
# The -50 offset is more likely to be the outlier, 
# but when a cell has a much higher apparent mito vol, then usually all the values are outside the typical range, no matter the threshold used. 
# The -25 rarely generates outliers.

# TODO: Calculate the range (fold change) between values obtained from different thresholds -- the (max - min) / min
# TODO: Calculate the spread (range, SD) of data obtained from each threshold
# TODO: Save graphs
# TODO: Check other datasets 
