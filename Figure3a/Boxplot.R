# ==============================================
# Boxplot of viral phylum relative abundances across three habitats (Water, Virome, Sediment)
# The script reads abundance data, converts from wide to long format,
# sets factor orders, defines colors, and generates a publication‑ready boxplot with all data points
# ==============================================

# Load required libraries
library(readxl)   # For reading Excel files
library(tidyr)    # For data reshaping (pivot_longer)
library(dplyr)    # For data manipulation
library(ggplot2)  # For visualization

# 1. Read the abundance data (rows = samples, columns = viral phyla)
data <- read_excel("vOTU_Phylum.xlsx", sheet = "Sheet1")

# 2. Reshape data from wide to long format
# Each row becomes a combination of Sample, Group, Phylum, and its abundance
data_long <- data %>%
  pivot_longer(
    cols = -c(Group, SamplenName),   # Keep Group and SamplenName as identifiers
    names_to = "Phylum",             # New column for viral phylum names
    values_to = "Abundance"          # New column for abundance values
  )

# 3. Set the order of Phylum for plotting (horizontal axis)
phylum_order <- c(
  "Uroviricota", "Preplasmiviricota", "Taleaviricota",
  "Peploviricota", "Hofneiviricota", "Cossaviricota",
  "Cressdnaviricota", "Phixviricota", "Nucleocytoviricota",
  "Others"
)
data_long$Phylum <- factor(data_long$Phylum, levels = phylum_order)

# 4. Set the order of Group (legend order and boxplot grouping)
group_order <- c("Water", "Virome", "Sediment")
data_long$Group <- factor(data_long$Group, levels = group_order)

# 5. Define custom colors for each habitat (adjustable)
my_colors <- c(
  "Water" = "#0093d9",    # Blue
  "Virome" = "#ff8080",   # Red/pink
  "Sediment" = "#f2b77c"  # Orange/brown
)

# 6. Create the boxplot with all individual points overlaid
p <- ggplot(data_long, aes(x = Phylum, y = Abundance, fill = Group)) +
  
  # Boxplot layer (without outlier points, as we will show all points individually)
  geom_boxplot(
    position = position_dodge(0.8),  # Dodge to avoid overlap between groups
    width = 0.7,                     # Box width
    outlier.shape = NA,              # Hide outliers (use geom_point for all points)
    alpha = 0.8                      # Slight transparency
  ) +
  
  # Add all individual data points (jittered to avoid overplotting)
  geom_point(
    position = position_jitterdodge(
      jitter.width = 0.2,            # Horizontal jitter amount
      dodge.width = 0.8,             # Dodge width matching the boxplot
      seed = 123                     # Fixed random seed for reproducible jitter
    ),
    size = 1.5,                      # Point size
    alpha = 1,                       # Fully opaque
    aes(color = Group)               # Color points by Group (matching box fill)
  ) +
  
  # Apply custom color scales for both fill and color aesthetics
  scale_fill_manual(values = my_colors) +
  scale_color_manual(values = my_colors) +
  
  # Labels and titles
  labs(
    title = "Viral phylum abundance across habitats",
    x = "Phylum",
    y = "Relative abundance (%)",
    fill = "Habitat",
    color = "Habitat"
  ) +
  
  # Minimal theme with white background
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 10),  # Rotate x-axis labels for readability
    axis.text.y = element_text(size = 10),
    legend.position = "right",
    plot.title = element_text(hjust = 0.5)                         # Center the title
  )

# Display the plot
print(p)

# Save the plot to a PDF file (adjustable dimensions)
ggsave("Boxplot_Viral_Phylum_with_points.pdf", plot = p, width = 12, height = 5)
