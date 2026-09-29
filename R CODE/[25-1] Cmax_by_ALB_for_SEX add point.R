# Load necessary libraries
library(ggplot2)

# Read the data
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/Cmax/Cmax_SUM.csv")

# Replace 'SEX' values
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# Create the box plot with individual data points
plot <- ggplot(data, aes(x = as.factor(ALB), y = Cmax, fill = SEX)) +
  geom_boxplot(outlier.shape = NA) +  # Hide outliers to avoid duplication with geom_jitter
  geom_jitter(position = position_jitter(width = 0.2), aes(color = SEX), alpha = 0.6) +  # Add jittered points
  scale_y_continuous(breaks = seq(185, 220, by = 5), limits = c(187, 218)) +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "skyblue")) +
  scale_color_manual(values = c("Female" = "pink", "Male" = "skyblue")) +  # Color points according to SEX
  labs(x = "ALB (g/dL)", y = "Cmax (ng/mL) ", fill = "SEX", title = "Cmax by Albumin for SEX") +
  theme_minimal()

# Save the plot to a PNG file
ggsave(filename = "Cmax_plot_ALB.png", plot = plot, width = 8, height = 6, dpi = 300)
