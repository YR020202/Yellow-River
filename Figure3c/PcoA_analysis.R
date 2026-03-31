# ==============================================
# PCoA of viral community composition based on Bray-Curtis distances
# The script reads an abundance table and metadata, performs PERMANOVA,
# and visualizes the results with a PCoA plot showing spatial trajectories
# ==============================================

# Load required packages
library(vegan)      # For distance calculation and PERMANOVA
library(ggplot2)    # For visualization
library(dplyr)      # For data manipulation
library(ggrepel)    # For non-overlapping text labels

# Set working directory (adjust to your local path)
setwd("D:/WYR/PcoA_analysis")

# Clear the environment
rm(list = ls())

# Read the abundance table (rows = MAGs/vOTUs, columns = samples)
abundance_table <- read.csv("vOTUs.csv", row.names = 1)

# Read metadata (rows = samples, columns = sample attributes)
metadata <- read.csv("metadata.csv", row.names = 1)

# Verify that sample names match between the abundance table and metadata
all(colnames(abundance_table) == rownames(metadata)) 

# Calculate Bray-Curtis dissimilarity matrix (transpose so samples are rows)
dist_bray <- vegdist(t(abundance_table), method = "bray")

# Perform Principal Coordinate Analysis (PCoA) with 2 dimensions
pcoa <- cmdscale(dist_bray, k = 2, eig = TRUE)

# Extract the sample coordinates in the reduced space
pcoa_df <- as.data.frame(pcoa$points)
colnames(pcoa_df) <- c("PCo1", "PCo2")

# Calculate the variance explained by each principal coordinate
eig <- pcoa$eig
var_exp <- round(eig / sum(eig) * 100, 1)

# Combine PCoA coordinates with metadata
plot_data <- cbind(metadata, pcoa_df)

# Perform PERMANOVA (adonis) to test the effect of "Segment" on community composition
permanova <- adonis2(dist_bray ~ Segment, data = metadata, permutations = 999)
print(permanova)

# Arrange samples by their geographical order (optional, for trajectory plotting)
plot_data <- plot_data %>%
  arrange(Order)   # Sort by the 'Order' column to define the path direction

# Create the PCoA plot with ggplot2
p <- ggplot(plot_data, aes(x = PCo1, y = PCo2)) +
  
  # Add a trajectory line connecting samples in geographical order (with arrow)
  geom_path(aes(group = 1),           # group=1 connects all points in the current order
            colour = "gray50", 
            size = 1,
            arrow = arrow(type = "closed", length = unit(0.2, "cm"))) +  # Arrow indicates direction
  
  # Add points colored by "Segment" (e.g., river reaches)
  geom_point(aes(color = Segment), size = 5, alpha = 0.8) +
  
  # Add sample labels using ggrepel to avoid overlapping
  geom_text_repel(aes(label = SampleName), 
                  size = 5, 
                  box.padding = 0.3, 
                  point.padding = 0.2,
                  segment.color = "grey50") +
  
  # Optional: Add 95% confidence ellipses for each group
  stat_ellipse(aes(color = Segment), type = "norm", level = 0.95, linetype = "dashed") +
  
  # Set axis labels with variance explained percentages
  labs(x = paste0("PCo1 (", var_exp[1], "%)"),
       y = paste0("PCo2 (", var_exp[2], "%)"),
       title = "PCoA of viral community (Bray-Curtis)") +
  
  # Apply a clean theme
  theme_bw() +
  theme(legend.title = element_blank(),
        legend.position = "right")

# Display the plot
print(p)
