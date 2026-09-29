# Load necessary libraries
library(ggplot2)

# Read the data
data <- read.csv("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/VER2/SIMULATION/CSV_simu/SIM_NAME/CONC_MEAN/CMAX_SUM.csv")

# Replace 'SEX' values
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# Create the box plot
plot <- ggplot(data, aes(x = as.factor(WT), y = PRED, fill = SEX)) +
  geom_boxplot() +
  scale_y_continuous(breaks = seq(280, 320, by = 5), limits = c(280, 310)) +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "skyblue")) +
  labs(x = "Weight (g/dL)", y = "Cmax (ng/mL) ", fill = "SEX", title = "Cmax by Albumin for SEX") +
  theme_minimal()

print(plot)
# Save the plot to a PNG file
#ggsave(filename = "Cmax_plot_WT.png", plot = plot, width = 8, height = 6, dpi = 300)
