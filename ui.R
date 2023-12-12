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
                   p("The dataset comes from", a("Kaggle.", href = "https://www.kaggle.com/datasets/uom190346a/sleep-health-and-lifestyle-dataset/data"),"It includes sleep metrics such as sleep duration and sleep disorders, lifestyle factors such as occupation, and health metrics such as BMI and heart rate measurements. For the purpose of this project, the categorical variables were converted to factors."
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
                   h3("Select gender"),
                   selectizeInput("gender", "Gender", selected = "Female", choices = levels(sleep_data$Gender)),
                   br(),
                   radioButtons("plotType","Choose plot type",
                                choices = list("Bar Plot",
                                               "Histogram",
                                               "Scatter Plot",
                                               "Box Plot"),
                                selected = "Bar Plot"),
                   selectInput("xVar", "Select Categorical Variable",
                               choices = list("Gender",
                                              "Occupation",
                                              "BMI.Category",
                                              "Sleep.Disorder"),
                               selected = "Gender"),
                   selectInput("yVar", "Select Continuous Variable",
                               choices = list("Quality.of.Sleep",
                                              "Sleep.Duration",
                                              "Age",
                                              "Daily.Steps"),
                               selected = "Age"),
                   radioButtons("summaryType", "Choose summary type",
                                choices = list("Contingency Table",
                                               "Mean",
                                               "Variance",
                                               "Standard Deviation",
                                               "Inter-quartile Range")),
                   conditionalPanel(condition = "input.plotType==Scatter Plot",
                                    checkboxInput("Occupation", h5("Also change symbol based on Occupation?")))
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
                          mainPanel("This app employs two types of predictive modeling; Mulitple Linear Regression and a Random Forest Model")
                ),
                 tabPanel("Model Fitting",
                ),
                 tabPanel("Prediction",
                ),
               )
               )
    ),
))

