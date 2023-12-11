#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  reactivePlot <- reactive({

        # generate plots based on input$plotType from ui.R
        if (input$plotType == "Bar Plot"){
          ggplot(data = sleep_data, aes(x = input$xVar)) +
            geom_bar()
        } else{
          ggplot(data = sleep_data, aes(x = input$xVar, y = input$yVar)) + geom_boxplot()
        }

    })
    #Render the plot
  output$myPlot <- renderPlot({
    reactivePlot()
  })
    output$summaryType <- renderDataTable({
      
      # generate data tables based input$summaryType from ui.R
      if (input$summaryType == "Contingency Table"){
        table(sleep_data$Gender, sleep_data$Occupation)
      } else if(input$summaryType == "Mean"){
        tab <- sleep_data %>%
          select("Gender", "BMI.Category", "Sleep.Duration") %>%
          group_by(Gender, BMI.Category) %>%
            summarize(mean = mean(Sleep.Duration))
    } else{
        sd(sleep_data$Sleep.Duration)
      }
        
      }
    )

})
