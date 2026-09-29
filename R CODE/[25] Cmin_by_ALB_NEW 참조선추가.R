# Load necessary libraries
library(ggplot2)
library(RColorBrewer)

setwd("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/Cmin")

# Load the data
data <- read.csv("C:/Users/Clinical/Desktop/MBMA/osimertinib/NONMEM/SIM/VER3/SIM/Cmax/Cmin/Cmin_SUM.csv")

# Create the box plot with custom category names
plot <- ggplot(data, aes(x = as.factor(ALB), y = Cmin, fill = as.factor(ALB))) +
  geom_boxplot() +
  labs(title = "Cmin by Albumin", x = "Albumin (g/dL)", y = "Cmin (ng/mL)") +
  theme_minimal() +
  scale_fill_manual(
    values = RColorBrewer::brewer.pal(length(unique(data$ALB)), "Set3"),
    name = "Albumin",
    labels = paste("", unique(data$ALB))
  ) +
  geom_hline(yintercept = c(166, 259), linetype = "dashed", color = "red") # Add reference lines

print(plot)

# Save the plot as a PNG file
ggsave("Cmin_by_Albumin.png", plot = plot, width = 8, height = 6)
