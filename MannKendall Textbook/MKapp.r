# Load the necessary packages
library(shiny)
library(ggplot2)
library(grid)   # For unit function in arrow length
library(scales) # For rescale function

# Define the user interface
ui <- fluidPage(
   titlePanel("Interactive Mann-Kendall Statistic Calculator with Trend and Variability Sliders"),

   # Controls above the main plot
   fluidRow(
           column(12,
             h4("Instructions:"),
             p("Specify the length of the time series, trend strength, and variability. Click 'Generate Data' to create the time series. Use the slider to move through each timestep. The plot highlights the current timestep and shows comparisons to future values and the cumulative score (S) is displayed on the right side."),
             br(),
      )
   ),
   # Controls above the main plot
   fluidRow(
      column(4,
             numericInput("n_input", "Time Series Length (n):", value = 30, min = 5),
             actionButton("generate_data", "Generate Data")
      ),
      column(4,
             sliderInput("trend_strength", "Trend Strength:",
                         min = -1, max = 1, value = 0, step = 0.1,
                         ticks = FALSE)
      ),
      column(4,
             sliderInput("variability", "Variability (Noise Level):",
                         min = 0, max = 20, value = 5, step = 1)
      ),
      br()
   ),

   # Main content: Plot and Calculations side by side
   fluidRow(
      column(8,
             plotOutput("time_series_plot"),
             sliderInput("timestep_slider", "Select Timestep:", min = 1, max = 1, value = 1, step = 1)
      ),
      column(4,
             h4("Calculations for Current Timestep:"),
             verbatimTextOutput("total_positive"),
             verbatimTextOutput("total_negative"),
             verbatimTextOutput("score_timestep"),
             h3(textOutput("cumulative_score"), style = "color: #1c63a5; font-weight: bold; font-size: 24px;")
      )
   )
)

# Define the server logic
server <- function(input, output, session) {

   # The Mann-Kendall statistic function with calculation details
   mann_kendall_statistic_details <- function(x) {
      n <- length(x)
      S <- 0
      calculations <- data.frame()
      cumulative_S_per_timestep <- numeric(n - 1)

      for (timestep in 1:(n - 1)) {
         now <- x[timestep]
         forward_values <- x[(timestep + 1):n]
         forward_positions <- (timestep + 1):n
         differences <- forward_values - now

         # Count positive and negative differences
         count_positive <- sum(differences > 0)
         count_negative <- sum(differences < 0)

         # Calculate S for this timestep
         S_timestep <- count_positive - count_negative
         S <- S + S_timestep

         # Record cumulative S for this timestep
         cumulative_S_per_timestep[timestep] <- S

         # Record each comparison
         for (i in seq_along(forward_values)) {
            sign <- ifelse(differences[i] > 0, "Positive",
                           ifelse(differences[i] < 0, "Negative", "Zero"))
            calculations <- rbind(calculations, data.frame(
               Timestep = timestep,
               Current_Position = timestep,
               Current_Value = now,
               Forward_Position = forward_positions[i],
               Forward_Value = forward_values[i],
               Difference = differences[i],
               Sign = sign
            ))
         }
      }

      return(list(S = S, calculations = calculations, cumulative_S_per_timestep = cumulative_S_per_timestep))
   }

   # Generate the time series data based on user input
   data_input <- eventReactive(input$generate_data, {
      n <- input$n_input
      trend_strength <- input$trend_strength  # Range from -1 to +1
      variability <- input$variability        # Controls noise level

      # Generate a base sequence from 1 to n
      base_sequence <- 1:n

      # Apply trend based on the trend_strength
      trend_component <- trend_strength * base_sequence

      # Add noise
      noise <- rnorm(n, mean = 0, sd = variability)

      # Combine trend and noise
      x <- trend_component + noise

      # Rescale the data to be between 0 and 100
      x <- rescale(x, to = c(5, 100))

      # Ensure no repeated values
      x <- jitter(x, amount = 1e-8)

      # Return the generated data
      x
   })

   # Calculate the Mann-Kendall statistic and prepare data
   result <- reactive({
      x <- data_input()
      if (is.null(x) || length(x) < 2) {
         return(NULL)
      } else {
         res <- mann_kendall_statistic_details(x)
         updateSliderInput(session, "timestep_slider", min = 1, max = length(x) - 1, value = 1)
         return(res)
      }
   })

   # Reactive expression to compute current calculations
   current_calculations <- reactive({
      res <- result()
      if (!is.null(res)) {
         timestep <- input$timestep_slider
         calculations <- res$calculations
         calculations_current <- calculations[calculations$Timestep == timestep, ]
         # Compute total positive and total negative
         total_positive <- sum(calculations_current$Sign == "Positive")
         total_negative <- sum(calculations_current$Sign == "Negative")
         # Score for this timestep
         score_timestep <- total_positive - total_negative
         # Cumulative score (S) up to this timestep
         cumulative_score <- res$cumulative_S_per_timestep[timestep]

         # Return the computed values
         list(
            total_positive = total_positive,
            total_negative = total_negative,
            score_timestep = score_timestep,
            cumulative_score = cumulative_score
         )
      } else {
         NULL
      }
   })

   # Render the total positive
   output$total_positive <- renderText({
      calc <- current_calculations()
      if (!is.null(calc)) {
         paste("Total Positive:", calc$total_positive)
      } else {
         ""
      }
   })

   # Render the total negative
   output$total_negative <- renderText({
      calc <- current_calculations()
      if (!is.null(calc)) {
         paste("Total Negative:", calc$total_negative)
      } else {
         ""
      }
   })

   # Render the score for this timestep
   output$score_timestep <- renderText({
      calc <- current_calculations()
      if (!is.null(calc)) {
         paste("Score for this timestep:", calc$score_timestep)
      } else {
         ""
      }
   })

   # Render the cumulative score prominently
   output$cumulative_score <- renderText({
      calc <- current_calculations()
      if (!is.null(calc)) {
         paste("Cumulative Score (S):", calc$cumulative_score)
      } else {
         ""
      }
   })

   # Render the time series plot with enhanced bar chart
   output$time_series_plot <- renderPlot({
      res <- result()
      if (!is.null(res)) {
         x_values <- data_input()
         n <- length(x_values)
         timestep <- input$timestep_slider

         # Create the data frame for plotting
         plot_data <- data.frame(Position = 1:n, Value = x_values)

         # Base plot with light grey bars for past timesteps
         p <- ggplot(plot_data, aes(x = Position, y = Value)) +
            geom_col(data = subset(plot_data, Position < timestep), fill = "gray90", width = 0.9) +  # Greyed out past bars
            geom_col(data = subset(plot_data, Position >= timestep), fill = "#b8d4ea", width = 0.9) +  # Blue bars for current and future bars
            labs(x = "Position", y = "Value", title = paste("Time Series Plot - Timestep", timestep)) +
            theme_minimal() +
            theme(
               panel.grid.major = element_line(color = "gray90"),
               panel.grid.minor = element_blank(),
               panel.background = element_rect(fill = "white"),
               axis.title = element_text(size = 12),
               axis.text = element_text(size = 10),
            )+
            scale_y_continuous(expand = c(0,0),limits = c(0, 110))+
            scale_x_continuous(expand = c(0,0),limits = c(0, n))


         # Highlight the current timestep with a darker color and point
         p <- p +
            geom_col(data = plot_data[timestep, ], aes(x = Position, y = Value), fill = "#1c63a5", width = 0.9) +
            geom_point(data = plot_data[timestep, ], aes(x = Position, y = Value), color = "#1c63a5", size = 3)

         # Add arrows from current timestep to future values
         forward_positions <- (timestep + 1):n
         if (length(forward_positions) > 0) {
            differences <- x_values[forward_positions] - x_values[timestep]
            signs <- ifelse(differences > 0, "Positive",
                            ifelse(differences < 0, "Negative", "Zero"))
            arrow_colors <- ifelse(signs == "Positive", "#1c63a5",
                                   ifelse(signs == "Negative", "#d53e4f", "#4d4d4d"))

            # Adjust arrow positions to not overlap with the bars
            gap <- 0.2  # Adjust this value to change the gap size
            x1 <- timestep
            x2 <- forward_positions
            y1 <- x_values[timestep]
            y2 <- x_values[forward_positions]

            # Shorten arrows slightly
            x1_adj <- x1 + gap
            x2_adj <- x2 - gap

            # Prepare data for plotting arrows
            arrow_data <- data.frame(
               x1 = x1_adj,
               y1 = y1,
               x2 = x2_adj,
               y2 = y2,
               Sign = signs,
               Color = arrow_colors
            )

            # Add arrows with finer line width and larger arrowheads
            p <- p + geom_segment(data = arrow_data,
                                  aes(x = x1, y = y1, xend = x2, yend = y2, color = Sign),
                                  size = 0.25,  # Finer line width
                                  arrow = arrow(length = unit(0.15, "cm"), type = "closed"))

            # Define colors for positive and negative differences
            p <- p + scale_color_manual(values = c("Positive" = "#1c63a5", "Negative" = "#d53e4f", "Zero" = "#4d4d4d"))
         }

         # Remove legends (optional)
         p <- p + theme(legend.position = "none")

         # Add a thin black line from the top of the current timestep to the end on the right
         p <- p + geom_segment(aes(x = timestep, y = x_values[timestep],
                                   xend = n, yend = x_values[timestep]),
                               color = "#4d4d4d", size = 0.2)

         # Print the plot
         print(p)
      }
   })
}

# Run the application
shinyApp(ui = ui, server = server)

