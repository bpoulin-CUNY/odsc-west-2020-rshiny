###app.R###

require(shiny)
require(shinydashboard)
require(tidyverse)

#Front End
ui <- dashboardPage(
  dashboardHeader(title = "Central Limit Simulations"),
  dashboardSidebar(),
  dashboardBody(
    fluidRow(
      column(4, wellPanel(
        h3("Exponential Distribution Parameters"),
        selectInput("n_number", "Number of Exponential Random Values(n):",
                    c("1000" = 1000,
                      "10,000" = 10000,
                      "100,000" = 100000)),
        numericInput("lambda", "Lambda (rate):", 3, min = 1, max = 6, step=1),
        h3("Sampling Parameters"),
        sliderInput("samples", "Number of Samples:", 250, 10000, 500),
      )),
      column(8, plotOutput("skew_hist"))


)))

#Back End
server <- function(input, output) { 
  
  #traditional r function
  ### Updated this with your variables for the reactive components
  central_limiter <-function(lambda,  n_number, n_samples){
    set.seed(808)
    distribution<- rexp(n=n_number, rate = lambda)
    distribution_mean = as.character(round(mean(distribution),2))
    distribution_sd = as.character(round(sd(distribution),2))
    sample_means= c()
    for (sample in 1:n_samples){
      values = sample(distribution, size=35, replace = TRUE)
      sample_mean = mean(values)
      sample_means = c(sample_means, sample_mean)
      mean_of_means = as.character(round(mean(sample_means), 2))
      sd_of_means = as.character(round(sd(sample_means), 2))
    }
    par(mfrow=c(1,2))
    hist(distribution,
         breaks = 50,
         col = 'olivedrab4',
         main = 'Historgram of Exponential Distribution',
         xlab = paste('Random Exponential Values- Rate:', lambda))
    mtext(paste('Mean:', distribution_mean, 'Standard Deviation:', distribution_sd), side =3)
    hist(sample_means,
         breaks = 50,
         col = 'olivedrab3',
         main = 'Historgram of Sample Means from Original Distribution',
         xlab = 'Means of Samples')
    mtext(paste('Mean:', mean_of_means, 'Standard Deviation:', sd_of_means), side =3)
    
  }
  #####reactive component which updates the web page using the function!
  
  output$skew_hist <-renderPlot({central_limiter(input$lambda, input$n_number, input$samples)
  })
}


#Application Starter
shinyApp(ui, server)

