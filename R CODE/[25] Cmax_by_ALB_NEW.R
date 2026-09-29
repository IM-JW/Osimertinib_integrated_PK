# Load necessary libraries
library(ggplot2)

# Load the data
data <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER2/SIMULATION/CSV_simu/SIM_NAME/CONC_MEAN/CMAX_SUM.csv")

# Create the box plot with custom category names
plot <- ggplot(data, aes(x = as.factor(ALB), y = DV, fill = as.factor(ALB))) +
  geom_boxplot() +
  labs(title = "Cmax by Albumin", x = "Albumin (g/dL)", y = "Cmax (ng/mL)") +
  theme_minimal() +
  scale_fill_manual(
    values = RColorBrewer::brewer.pal(length(unique(data$ALB)), "Set3"),
    name = "Albumin",
    labels = paste("", unique(data$ALB))
  )

# Save the plot as a PNG file
ggsave("Cmax_by_Albumin.png", plot = plot, width = 8, height = 6)
