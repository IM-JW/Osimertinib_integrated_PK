# Load necessary libraries
library(ggplot2)

# Read the data
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/average_Cmax/Cmin_SUM.csv")

# Replace 'SEX' values
data$SEX <- factor(data$SEX, levels = c(0, 1), labels = c("Female", "Male"))

# Create the box plot
plot <- ggplot(data, aes(x = as.factor(ALB), y = Cmin, fill = SEX)) +
  geom_boxplot() +
  scale_y_continuous(breaks = seq(195, 215, by = 5), limits = c(195, 215)) +
  scale_fill_manual(values = c("Female" = "pink", "Male" = "skyblue")) +
  labs(x = "ALB (g/dL)", y = "Cmin (ng/mL) ", fill = "SEX", title = "Cmin by Albumin for SEX") +
  theme_minimal()


# Plot 화면에 출력
print(plot)
# Save the plot to a PNG file
#ggsave(filename = "Cmin_plot_ALB.png", plot = plot, width = 8, height = 6, dpi = 300)
