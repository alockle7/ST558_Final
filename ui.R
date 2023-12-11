#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sleep and Health Data"),

    #Define the UI for the tabs
    tabsetPanel(
      tabPanel("About",
               sidebarLayout(
                 sidebarPanel(
                   p("The purpose of this app is to provide an interactive platform where the user can ivestigate the relationship between sleep, health, and lifestyle factors."),
                   p("The dataset comes from", a("Kaggle.", href = "https://www.kaggle.com/datasets/uom190346a/sleep-health-and-lifestyle-dataset/data"),"It includes sleep metrics such as sleep duration and sleep disorders, lifestyle factors such as occupation, and health metrics such as BMI and heart rate measurements."
                   ),
                   p("This app is separated in tabs, the first tab describes the dataset and purpose of this app, the second tab plots data based on user inputs, and the third tab allows the user to select inputs for predictive modeling.")
                   ),
                 mainPanel(img(src="sleep.png") 
                 ),
               )
      ),
      tabPanel("Exploratory Data Analysis",
               sidebarLayout(
                 sidebarPanel(
                   radioButtons("plotType","Choose plot type",
                                choices = list("Bar Plot",
                                               "Scatter Plot", 
                                               "Histogram",
                                               "Box Plot"),
                                selected = "Bar Plot"),
                   radioButtons("summaryType", "Choose summary type",
                                choices = list("Contingency Table",
                                               "Mean",
                                               "Variance",
                                               "Standard Deviation",
                                               "Inter-quartile Range")),
                   selectInput("xVar", "Select X Variable",
                               choices = list("Gender",
                                              "Occupation",
                                              "BMI.Category",
                                              "Sleep Disorder")),
                   selectInput("yVar", "Select Y Variable",
                               choices = list("Sleep.Duration",
                                              "Quality.of.Sleep"))
                 ),
                 mainPanel(
                   plotOutput("myPlot"),
                   dataTableOutput("summaryType")
                 ),
               )
               ),
      tabPanel("Modeling",
               tabsetPanel(
                 tabPanel("Modeling Info",
                          h3("Modeling Info"),
                ),
                 tabPanel("Model Fitting",
                          h3("Model Fitting"),
                ),
                 tabPanel("Prediction",
                          h3("Prediction"),
                ),
               )
               )
    ),
))
