#User Interface - The Front End
ui <- fluidPage( #<- notice Fluid Methods
  titlePanel("censusVis"),
  #Styling for the page sidebarLayout, sidebarPanel, mainPanel
  sidebarLayout(
    sidebarPanel(
      helpText("Some Kind of Selector."),
      

      # input method
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = 50)
    ),
    
    mainPanel(
      textOutput("selected_var")
    )
  )
)

# The Back End - Where the hard work is done

server <- function(input, output) {
  #output method
  output$selected_var <- renderText({ 
   paste("You have selected this", input$range[])
  })
  
}

#Application Starting Method
shinyApp(ui, server)