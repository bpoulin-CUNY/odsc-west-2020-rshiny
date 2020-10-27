## app.R ##
library(shiny)
library(shinydashboard) #<- new package with enhanced styles and interactivity

# Front End
ui <- dashboardPage( #<- these style methods all start with dashboard
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

#Back Ennd
server <- function(input, output) { }


#Application Start Method
shinyApp(ui, server)