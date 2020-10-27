#import as normal
library(shiny)


#The Front End - UI
ui <- fluidPage(
  "This is the simplest Shiny Application you can build"
)

#The Back End Server
#Three Arguments that facilitate multiple users
server <- function(input, output, session) { 
}


#The Method calling the application to work
shinyApp(ui, server)
