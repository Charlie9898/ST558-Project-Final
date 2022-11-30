library(shiny)
library(ISLR2)
library(ggplot2)
dataset = na.omit(Hitters)
dataset$Salary = log(na.omit(Hitters$Salary))

shinyUI(fluidPage(
  
  # Application title
  titlePanel("ST558 Final Project - Predict Baseball Player's Salary"),
  navbarPage("Shiny App",
             tabPanel("About",
                      h2("Purpose"), "The purpose of this app is to predict the 
                      baseball player's salary using several statistical models.
                      The models used in this project contain multiple linear 
                      regression model, regression tree model, and random forest
                      model.",
                      
                      h2("Data"), "The data used in this app is the",code("Hitters"),
                      "dataset from the",code("ISLR2"),"library in R. The dataset 
                      can be found in ", a("James et al.",href="https://www.statlearning.com"),
                      "More information about the dataset can be found ",
                      a("here",href="https://www.rdocumentation.org/packages/ISLR2/versions/1.3-2/topics/Hitters"),".",
                      
                      h2("Pages"),"This app contains four pages, each page contain
                      several tabs.",br(), "The first",code("About"),"page provies an overview 
                      about the purpose of the app, the data used in the app, and
                      other related information. ",br(), "The second",code("Data Exploration"),
                      "page provides tools to explore the input data. Summary 
                      statistics and plots can be developed for the dataset. ",br(), "The 
                      third",code("Modeling"),"page provides the three statistical 
                      models used to predict salary. The modeling information, model 
                      fiting processes, model validation and prediction processes 
                      can be found in sub-tabs. ",br(), "The last",code("Data"),"page provides 
                      a toolbox to view, subset, and save the dataset.",br(),br(),
                      
                      img(src = "https://images.squarespace-cdn.com/content/v1/5ff2adbe3fe4fe33db902812/1611294680091-25SIDM9AHA8ECIFFST23/Screen+Shot+2021-01-21+at+11.02.06+AM.png?format=750w",
                          height = 315, width = 188)),
             
             
             tabPanel("Data Exploration",
                      sidebarPanel(
                          h3("This page provides a data exploration tool"),br(),
                          
                          "Subset Data:",
                          selectizeInput("year", "Year", choices = c("<10"="LT10",
                                                                     ">=10"="GE10")),
                          
                          h3("Data Exploration Plot"),
                          radioButtons(inputId = "PlotType",label = "Select the Plot Type",
                                       choices = c("Scatter Plot (X vs Y)"="SP",
                                                   "Histogram (Y)"="Hist",
                                                   "By Group Bar Chart (Average of Y by group)"="BC")),
                          
                          conditionalPanel(condition = "input.PlotType=='SP'",
                                           selectInput('xsp', 'X', names(dataset)),
                                           selectInput('ysp', 'Y', names(dataset), names(dataset)[[19]])),
                          
                          conditionalPanel(condition = "input.PlotType=='Hist'",
                                           selectInput('yhist', 'Y', names(dataset), names(dataset)[[19]])),
                          
                          conditionalPanel(condition = "input.PlotType=='BC'",
                                           selectInput('ybc', 'Y', names(dataset), names(dataset)[[19]]),
                                           selectInput('groupbc', 'Variable to Group by', 
                                                       c(names(dataset)[[14]],names(dataset)[[15]],names(dataset)[[20]]), names(dataset)[[14]])),
                          
                          h3("Data Exploration Table"),
                          radioButtons(inputId = "SummaryType",label = "Select the Summary Type",
                                       choices = c("Descriptive Statistics"="DS",
                                                   "Extreme Observations"="EO")),
                          
                          selectInput('ysummary', 'Y', names(dataset), names(dataset)[[19]]),

                        ),
                      mainPanel(
                        plotOutput("plot"),
                        tableOutput("table")
                        )
                      ),
            
             
             tabPanel("Modeling"),
             
             
             tabPanel("Data")
             )
        ))