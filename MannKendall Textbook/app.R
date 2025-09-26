# Load libraries
library(shiny)
library(Kendall)
library(ggplot2)
library(readr)  # Ensure read_csv is loaded for reading CSV files

# Load the dataset (adjust path as necessary)
data <- read_csv("Cyclic_Issues_in_Rainfall_Datasets.csv")

# Define UI for the application
ui <- fluidPage(
   titlePanel("Interactive Mann-Kendall Test with Irregular Large Impact"),

   mainPanel(
      plotOutput("timeSeriesPlot"),
      br(),
      sliderInput("yearRange",
                  "Select Year Range:",
                  min = 1,
                  max = nrow(data),
                  value = c(1, nrow(data)),
                  step = 1),
      br(),
      verbatimTextOutput("mk_stat")  # Changed to verbatimTextOutput for better text formatting
   )
)

# Define server logic
server <- function(input, output) {

   # Reactive subset of data based on selected range
   selectedData <- reactive({
      subset <- data[input$yearRange[1]:input$yearRange[2], "Irregular_Large_Impact_A", drop = TRUE]
      print(length(subset))  # Debugging: Print the length of subset to confirm it's updating
      subset
   })

   # Calculate Mann-Kendall statistic for the selected range
   output$mk_stat <- renderText({
      subset_data <- selectedData()
      if (length(subset_data) < 3) {
         return("Select at least 3 years to calculate the Mann-Kendall statistic.")
      }
      mk_result <- MannKendall(subset_data)
      paste("Mann-Kendall Tau:", round(mk_result$tau, 3),
            "| P-value:", round(mk_result$sl, 3))
   })

   # Plot the selected time series
   output$timeSeriesPlot <- renderPlot({
      ggplot(data[input$yearRange[1]:input$yearRange[2], ],
             aes(x = seq(input$yearRange[1], input$yearRange[2]),
                 y = Irregular_Large_Impact_A)) +
         geom_line(color = "steelblue", size = 1) +
         geom_point(color = "darkorange", size = 2) +
         labs(
            title = "Selected Time Series with Irregular Large Impact",
            x = "Year",
            y = "Value"
         ) +
         theme_minimal(base_size = 14) +
         theme(
            plot.title = element_text(hjust = 0.5, face = "bold"),
            axis.title.x = element_text(face = "bold"),
            axis.title.y = element_text(face = "bold")
         )
   })
}

# Run the application
shinyApp(ui = ui, server = server)

