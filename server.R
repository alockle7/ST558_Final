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
library(mathjaxr)
library(caret)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  getData <- reactive({
    newData <- sleep_data %>% filter(Gender == input$gender)
  })
  #Render the plot
  output$myPlot <- renderPlot({
    xVar <-input$xVar
    yVar <-input$yVar
        # generate plots based on input$plotType from ui.R
        if (input$plotType == "Bar Plot"){
          ggplot(data = sleep_data, aes_string(x = input$xVar)) +
            geom_bar()
        } else if (input$plotType == "Histogram"){
          ggplot(data = sleep_data, aes_string(x = yVar)) +
            geom_histogram()
          } else if (input$plotType == "Scatter Plot"& input$Occupation){
            ggplot(data = sleep_data, aes(x = Physical.Activity.Level, y = Sleep.Duration)) +
                     geom_point(aes(col = Occupation))
          } else if (input$plotType =="Scatter Plot"){
            ggplot(data = sleep_data, aes(x = Physical.Activity.Level, y = Sleep.Duration)) +
              geom_point()
           } else ggplot(data = sleep_data, aes_string(x = input$xVar, y = input$yVar)) + geom_boxplot()
        })
  
    output$summaryType <- renderDataTable({
      # generate data tables based input$summaryType from ui.R
      if (input$summaryType == "Contingency Table"){
        table(sleep_data$Gender, sleep_data$Occupation)
      } else {
        tab <- sleep_data %>%
          select("Gender", "BMI.Category", "Quality.of.Sleep") %>%
          group_by(Gender, BMI.Category) %>%
            summarize(mean = mean(Quality.of.Sleep))
    }
      }
    )

    output$modelfit <- renderPrint({
      set.seed(55)
      trctrl <-trainControl(method = "repeatedcv",
                            number = 5,
                            repeats = 3
      )
      if(input$modelType == "Generalized Linear Regression Model"){

      modelfit <- train(Quality.of.Sleep ~., sleep_data, method = "glm",
                      trControl = trctrl,
                      preProcess = c("center", "scale"))
      }else {modelfit <- train(Quality.of.Sleep ~., sleep_data, method = "rpart",
                            trControl = trctrl,
                            preProcess = c("center", "scale"))
      } 
      print(modelfit)
    })
    output$glmPred <- renderPrint({
      glmPred <- as.numeric(predict(glmFit, test,
                                      type = "prob")[,2] > 0.5)
      confMatGLM <- confusionMatrix(as.factor(glmPred), 
                                      as.factor(as.numeric(as.factor(test$sleep)) - 1),
                                      positive = "1")
      print(confMatGLM)
    })
})
