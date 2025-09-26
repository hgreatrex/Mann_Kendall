# Load the Shiny package
library(shiny)

# Define the user interface
ui <- fluidPage(
   titlePanel("Mann-Kendall Statistic Calculator"),

   sidebarLayout(
      sidebarPanel(
         textInput("data_input", "Enter your data (comma-separated):", value = "3, 1, 4, 2, 5"),
         actionButton("calculate", "Calculate")
      ),

      mainPanel(
         h3("Mann-Kendall Statistic Result"),
         verbatimTextOutput("result"),
         h3("Detailed Calculations"),
         tableOutput("calculations")
      )
   )
)

# Define the server logic
server <- function(input, output) {

   # The Mann-Kendall statistic function
   mann_kendall_statistic <- function(x) {
      n <- length(x)
      S <- 0
      calculations <- data.frame()

      for (i in 1:(n - 1)) {
         for (j in (i + 1):n) {
            diff <- x[j] - x[i]
            if (diff > 0) {
               S <- S + 1
               sign <- 1  # Positive trend
            } else if (diff < 0) {
               S <- S - 1
               sign <- -1 # Negative trend
            } else {
               sign <- 0  # No change
            }
            # Record each step
            calculations <- rbind(calculations, data.frame(
               Position_i = i,
               Position_j = j,
               Value_i = x[i],
               Value_j = x[j],
               Difference = diff,
               Sign = sign,
               Running_S = S
            ))
         }
      }

      return(list(S = S, calculations = calculations))
   }

   # Reactively process the input data when the button is clicked
   data_input <- eventReactive(input$calculate, {
      # Split the input text by commas and convert to numeric
      as.numeric(unlist(strsplit(input$data_input, ",")))
   })

   # Calculate the Mann-Kendall statistic
   result <- eventReactive(input$calculate, {
      x <- data_input()
      if (any(is.na(x))) {
         return(NULL)
      } else {
         mann_kendall_statistic(x)
      }
   })

   # Display the result
   output$result <- renderPrint({
      res <- result()
      if (is.null(res)) {
         cat("Please enter valid numeric data separated by commas.")
      } else {
         cat("The Mann-Kendall statistic S is:", res$S)
      }
   })

   # Display the detailed calculations
   output$calculations <- renderTable({
      res <- result()
      if (!is.null(res)) {
         res$calculations
      }
   })
}

# Run the application
shinyApp(ui = ui, server = server)
