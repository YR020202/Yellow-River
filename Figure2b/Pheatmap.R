# ==============================================
# Heatmap of viral family abundance across samples
# The script reads an abundance matrix and generates a customizable heatmap using pheatmap
# ==============================================

# Load required libraries
library(ggplot2)   # (Not directly used but often loaded alongside pheatmap for plotting)
library(pheatmap)  # For creating annotated heatmaps
library(vegan)     # (May be used for ecological analyses, not directly in this heatmap)

# Read the abundance data (rows = vOTU families, columns = samples)
data <- read.table("vOTU_Famliy_abundance.txt", header = TRUE, sep = "\t", row.names = 1)

# Generate the heatmap with customized parameters
p1 <- pheatmap(
  data,                                   # Matrix or data frame to be plotted
  
  # Color scheme: blue -> pink -> yellow (50 gradient levels)
  color = colorRampPalette(c('#2D1B8F', '#BA517F', '#F4ED5B'))(50),
  
  border_color = "black",                 # Border color of each cell (NA = no border)
  scale = "none",                         # No scaling; "row" or "column" would normalize by row/column
  cluster_rows = FALSE,                   # Disable row clustering (keep original order)
  cluster_cols = FALSE,                   # Disable column clustering (keep original order)
  legend = TRUE,                          # Display the color legend
  legend_breaks = c(-1, 0, 1),            # Custom break points for the legend
  legend_labels = c("low", "mid", "high"),# Labels corresponding to legend breaks
  show_rownames = TRUE,                   # Display row names (vOTU families)
  show_colnames = TRUE,                   # Display column names (samples)
  fontsize = 8                            # Base font size (row/col names can be adjusted separately)
)

# The resulting heatmap object p1 can be printed or saved (e.g., ggsave() or pheatmap's built-in filename)
