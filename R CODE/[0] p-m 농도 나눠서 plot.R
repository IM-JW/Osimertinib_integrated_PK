#setwd("C:/Users/isuji/Desktop/Ph.D/Research/Osimertinib/NONMEM/ID2000/TRY4")

# Load necessary libraries
library(ggplot2)
library(dplyr)

# Read the dataset
data <- read.csv("DATA1.csv")
print(dim(data))  # Print dimensions of the data

# Clean the data
data$DV[data$DV == "."] <- NA
data$DV <- as.numeric(as.character(data$DV))
data$TIME <- as.numeric(as.character(data$TIME))

# Check for NA values in DV
print(sum(is.na(data$DV)))  # Check for NA values

# Filter and combine data for plotting
data_filtered <- data %>%
  filter(CMT %in% c(2, 3)) %>%
  mutate(CMT_label = ifelse(CMT == 2, "Parent Drug Concentration", "Metabolite Concentration"))

print(dim(data_filtered))  # Check dimensions of the filtered data
print(head(data_filtered))  # Display the first few rows of filtered data

# Create the plot
ggplot(data_filtered, aes(x = TIME, y = DV, color = CMT_label, group = interaction(ID, CMT_label))) +
  geom_line() +
  geom_point() +
  labs(title = "Drug Concentration Over Time",
       x = "Time (hours)",
       y = "Concentration (DV)",
       color = "Concentration Type") +
  theme_minimal()
