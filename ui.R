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
                      
                      ),
            
             
             tabPanel("Modeling"),
             
             
             tabPanel("Data")
             )
        ))