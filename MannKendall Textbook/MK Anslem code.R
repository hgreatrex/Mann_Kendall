# Load necessary libraries
library(ggplot2)
library(readr)
library(dplyr)
library(gridExtra)

# Load the data
data <- read_csv("significant_mk_windows.csv")

# Set up a function to plot each series in a nice format
plot_time_series <- function(data, series_name, title) {
   ggplot(data, aes(x = 1:nrow(data), y = !!sym(series_name))) +
      geom_line(color = "steelblue", size = 1) +
      geom_point(color = "darkorange", size = 2) +
      labs(
         title = title,
         x = "Time (Index)",
         y = "Value"
      ) +
      theme_minimal(base_size = 14) +
      theme(
         plot.title = element_text(hjust = 0.5, face = "bold"),
         axis.title.x = element_text(face = "bold"),
         axis.title.y = element_text(face = "bold")
      )
}

# Generate plots for each series

# Irregular Large Impact (El Niño-like events)
plot_time_series(data, "Years","Years_0_to_29")
plot_time_series(data, "Years","Years_42_to_71")
plot_time_series(data, "Years","Years_42_to_71")


# Multi-Year or Decadal Cycles
p3 <- plot_time_series(data, "Multi_Year_Cycle_A", "Multi-Year Cycle - Dataset A")
p4 <- plot_time_series(data, "Multi_Year_Cycle_B", "Multi-Year Cycle - Dataset B")

# Seasonal Cyclicity with Long-Term Variability
p5 <- plot_time_series(data, "Annual_Seasonality_A", "Annual Seasonality with Drift - Dataset A")
p6 <- plot_time_series(data, "Annual_Seasonality_B", "Annual Seasonality with Drift - Dataset B")

# Step Changes or Abrupt Shifts
p7 <- plot_time_series(data, "Step_Change_A", "Step Change - Dataset A")
p8 <- plot_time_series(data, "Step_Change_B", "Step Change - Dataset B")

# Nonstationary Cyclicity Due to Climate Change
p9 <- plot_time_series(data, "Nonstationary_Cycle_A", "Nonstationary Cycle - Dataset A")
p10 <- plot_time_series(data, "Nonstationary_Cycle_B", "Nonstationary Cycle - Dataset B")

# Print plots
grid.arrange(p1, p2, ncol = 2)
grid.arrange(p3, p4, ncol = 2)
grid.arrange(p5, p6, ncol = 2)
grid.arrange(p7, p8, ncol = 2)
grid.arrange(p9, p10, ncol = 2)
grid.arrange(p9, p10, ncol = 2)
print(p7)
print(p8)
print(p9)
print(p10)
