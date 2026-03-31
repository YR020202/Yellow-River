# ==============================================
# Boxplot of vOTU length distribution across different quality categories
# The script reads vOTU quality data from an Excel file, reshapes it,
# and generates a boxplot with mean markers, customized colors, and y‑axis limits
# ==============================================

# Load required libraries
library(ggplot2)   # For visualization
library(dplyr)     # For data manipulation (not directly used but loaded)
library(readxl)    # For reading Excel files
library(reshape2)  # For melting (reshaping) the data frame

# Read the vOTU quality data from an Excel file (Sheet1)
# The file is expected to contain columns: group (quality category) and value (vOTU length in bp)
data <- read_excel('vOTUquality.xlsx', sheet = "Sheet1")

# Reshape the data from wide to long format using melt()
# This creates two columns: 'variable' (original column names) and 'value'
data_m <- melt(data)

# The comment "#Gene number (frequency)" seems outdated; we interpret it as part of the original script
# Convert the 'group' column (which likely came from the original data) into an ordered factor
# The levels define the order of categories on the x‑axis
data_m$group <- factor(data_m$group, 
                       levels = c('High-quality', 'Medium-quality', 'Low-quality', 'Not-determined'))

# Create the boxplot using ggplot2
ggplot(data_m, aes(x = group, y = value), color = group) + 
  
  # Add boxplot layer: no outliers displayed (outlier.shape = NA), fill by group, line size 0.5
  geom_boxplot(outlier.shape = NA, aes(fill = factor(group)), size = 0.5) +
  
  # Set y‑axis limits from 0 to 80,000 bp (zoom in without removing data points)
  coord_cartesian(ylim = c(0, 80000)) +
  
  # Add mean points (cross markers) for each group
  stat_summary(fun.y = mean, geom = "point", 
               aes(group = factor(group)), 
               position = position_dodge(0.9), 
               pch = 4,        # Cross shape
               color = "black", 
               size = 4) +
  
  # Manually define fill colors for the four quality categories
  scale_fill_manual(breaks = c('High-quality', 'Medium-quality', 'Low-quality', 'Not-determined'),
                    values = c('#EEA599', '#FAC795', '#FFE9BE', '#E3EDE0')) +
  
  # Axis labels
  labs(x = 'Group', 
       y = 'CheckV quality to vOTUs length (bp)', 
       color = 'Type') +
  
  # Use a clean test theme (theme_test)
  theme_test() +
  
  # Customize theme elements for publication‑ready appearance
  theme(
    axis.title = element_text(size = 9),
    axis.text.x = element_text(hjust = 0.5, size = 4.5, colour = 'black'),
    axis.text.y = element_text(size = 4.5, colour = 'black'),
    axis.ticks = element_line(size = 0.2),
    axis.ticks.length = unit(0.03, "cm"),
    panel.border = element_rect(size = 0.35)
  ) +
  
  # Remove the legend (since the fill colors are self‑explanatory or the legend is not needed)
  theme(legend.position = 'none')
