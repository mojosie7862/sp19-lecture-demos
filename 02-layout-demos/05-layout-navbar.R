library(shiny)
library(shinythemes)

ui <- navbarPage(
  theme = shinytheme("superhero"),
  "Andrey's wonderful tabbed app",

  tabPanel(
    "Old Faithful Geyser Data",
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("bins",
          "Number of bins:",
          min = 1,
          max = 50,
          value = 30
        )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel("Plot", plotOutput("distPlot")),

          tabPanel("Summary", textOutput("summaryText")),

          tabPanel("Table", tableOutput("data"))
        )
      )
    )
  ),
  
  tabPanel(
    "Iris Flowers",
    
    sidebarLayout(
      sidebarPanel(
        sliderInput("numFlowers",
                    "Number of flowers to show:",
                    min = 1,
                    max = 150,
                    value = 50
        )
      ),
      mainPanel(
        tableOutput("irisPlot")
      )
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = "darkgray", border = "white")
  })

  output$summaryText <- renderText({
    paste("We are showing Old Faithful Geyser Data with", input$bins, "bins")
  })

  output$data <- renderTable({
    x <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist_data <- hist(x, breaks = bins, plot = FALSE)
    data.frame(
      midpoint = hist_data$mids,
      counts = hist_data$counts
    )
  })
  
  output$irisPlot <- renderTable({
    head(iris, input$numFlowers)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
