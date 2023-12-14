#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

#Include MathJax librqary in header
tags$head(
  tags$script(
    type = "text/javascript",
    src = "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.9/MathJax.js?config=TeX-MML-AM_CHTML"
  )
)
#import data. 
url <- "https://raw.githubusercontent.com/alockle7/ST558_Final/main/Sleep_health_and_lifestyle_dataset.csv"
#Save as R object
sleep_data <<- read.csv(url)

#convert categorical variables to factors
sleep_data$Gender <<- as.factor(sleep_data$Gender)
sleep_data$Occupation <<- as.factor(sleep_data$Occupation)
sleep_data$BMI.Category <<-as.factor(sleep_data$BMI.Category)
sleep_data$Sleep.Disorder <<-as.factor(sleep_data$Sleep.Disorder) 
sleep_data$Blood.Pressure <<-NULL


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
                   p("This app is separated in tabs, the first tab describes the dataset and purpose of this app, the second generates plots and data tables based on user inputs, and the third tab allows the user to select inputs for predictive modeling.")
                   ),
                 mainPanel(img(src="sleep.png") 
                 ),
               )
      ),
      tabPanel("Exploratory Data Analysis",
               sidebarLayout(
                 sidebarPanel(
                   selectizeInput("gender", "Filter results by gender", selected = "Female", choices = levels(as.factor(sleep_data$Gender))),
                   br(),
                   radioButtons("plotType","Choose plot type",
                                choices = list("Bar Plot",
                                               "Histogram",
                                               "Scatter Plot",
                                               "Box Plot"),
                                selected = "Bar Plot"),
                   conditionalPanel(condition = "input.plotType==Scatter Plot",
                                    checkboxInput("Occupation", h5("Also change symbol based on Occupation?"))),
                   selectInput("xVar", "Select Categorical Variable",
                               choices = list("Occupation",
                                              "BMI.Category",
                                              "Sleep.Disorder"),
                               selected = "Occupation"),
                   selectInput("yVar", "Select Continuous Variable",
                               choices = list("Quality.of.Sleep",
                                              "Sleep.Duration",
                                              "Age",
                                              "Daily.Steps"),
                               selected = "Age"),
                   radioButtons("summaryType", "Choose summary type",
                                choices = list("Contingency Table",
                                               "Mean"))
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
                          mainPanel(
                            p("This app employs two types of predictive modeling; Generalized Linear Regression and a Random Forest Model"),
                            br(),
                            p("The General Linear Model(GLM)encompasses various types of linear models. It includes not only multiple linear regression but also other models, such as analysis of variance (ANOVA) and analysis of covariance (ANCOVA), as special cases. GLM can handle a wider range of situations, including models where the response variable follows a non-normal distribution.They offer a flexible framework for modeling a wide range of data types"),
                            br(),
                            p("The Random Forest Model is built on the foundation of decision trees. Decision trees are simple models that make decisions based on a series of hierarchical, binary choices. Each decision is based on a feature, and the tree branches out until a decision is reached.A Random Forest consists of a collection (or ensemble) of decision trees. The forest part comes from the idea of combining multiple trees to create a more robust and accurate model. When building each tree in the ensemble, Random Forest introduces randomness in the feature selection process. Instead of using all features to split nodes, it randomly selects a subset of features for each split. This helps to decorrelate the trees and makes the model less prone to overfitting.")
                )),
                 tabPanel("Model Fitting",
                          sidebarLayout(
                            sidebarPanel(
                              radioButtons("modelType", "Select the model type",
                              choices = list("Generalized Linear Regression Model",
                                             "Random Forest Model")),
                              checkboxGroupInput("checkGroup", "Choose the predictor variables",
                              choices = list("Gender",
                                             "Age",
                                             "Occupation",
                                             "BMI.Category",
                                             "Daily.Steps")),
                              ),
                            mainPanel(verbatimTextOutput("modelfit")
                            )
                          )
                 ),
                 tabPanel("Prediction",
                          sidebarLayout(
                            sidebarPanel(
                              h3("Select predictor values for the Generalized Linear Model"),
                              radioButtons("glmGender", "Select gender",
                                           choices = list("Male",
                                                          "Female")),
                              radioButtons("glmOccupation", "Select Occupation",
                                           choices = levels(sleep_data$Occupation)),
                              radioButtons("glmBMI", "Select BMI Category",
                                           choices = levels(sleep_data$Sleep.Disorder)),
                            ),
                            mainPanel(verbatimTextOutput("glmPred")
                          )
                ),
               )
    ),
))
))
