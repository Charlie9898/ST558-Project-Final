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
            
             
             tabPanel("Modeling",
                      h3("This page provides three supervised learning models"),br(),
                      navbarPage("",
                                 tabPanel("Modeling Info",
                                          h4("Model 1: Multiple Linear Regression"),
                                          "Linear regression is a simple supervised learning tool for modeling a 
                               quantitative response. It is much simpler compared to other modern 
                               techniques; however, such models are still very useful in developing 
                               new methods. In fact, many flexible nonparametric models can be 
                               though of generalizations of linear regression model. Practically, in 
                               real data, often we see relationships that locally linear. ",br(),
                                          "A linear regression model has the form",
                                          withMathJax(helpText('$$Y_i=\\beta_0+X_{i1}\\beta_1+X_{i2}\\beta_2+
                                                    ...+X_{ip}\\beta_p+\\epsilon_i$$')),
                                          withMathJax(('where \\(Y_i\\) is a quantitative response, 
                                        \\(X_{i1},...,X_{ip}\\) are predictor variables, 
                                        and \\(\\epsilon_i\\) is unobserved random error.')),
                                          "The benefit of linear regression is that it performs 
                               exceptionally well for linearly separable data; it is 
                               easier to implement, interpret and efficient to train. 
                               The drawback of it are that it requires linearity assumption
                               between dependent and independent variables; it is also 
                               quite prone to noise and overfitting.",br(),
                                          
                                          h4("Model 2: Regression Tree Model"),
                                          "A regression tree is built through a process known as binary recursive 
                               partitioning, which is an iterative process that splits the data into 
                               partitions or branches, and then continues splitting each partition into 
                               smaller groups as the method moves up each branch.",br(),
                                          withMathJax(('Suppose first that we have partitioned the data 
                                                    into M regions \\(R_1,R_2,...,R_M\\). Therefore, 
                                                    for this configuration of regions, we have the 
                                                    residual sum of squares RSS')),
                                          "In tree-based methods, we construct the regions dynamically from 
                               the data. Thus one might try to regions \\(R_1,...,R_M\\) that minimize the RSS.",
                                          "Compared to other algorithms decision trees requires less effort for data 
                               preparation during pre-processing. A decision tree does not require normal
                               ization of data. However, a small change in the data can cause a large 
                               change in the structure of the decision tree causing instability. Decision 
                               tree also often involves higher time to train the model.",br(),
                                          
                                          h4("Model 3: Random Forest Model"),
                                          "Random forests provide an improvement over bagging by decorrelating the 
                               trees. Consider the situation where there is one very strong predictor in 
                               the data set, along with a number of other moderately strong predictors. 
                               Then most or all of the trees in the collection of bagged trees will use 
                               the strong predictor in the top split. Thus, all of the bagged trees will 
                               look quite similar to each other, and the predictions from the bagged 
                               trees will be highly correlated. ", br(),
                                          "Random forests overcome this problem by forcing each split to consider 
                               only a subset of the predictors. As in bagging, we build a number of 
                               decision trees on bootstrapped training samples. But when building these 
                               decision trees, each time a split in a tree is considered, a random 
                               sample of m predictors is chosen as split candidates from the full set of 
                               p predictors.",br(),
                                          "Random Forest is based on the bagging algorithm and uses Ensemble Learning 
                               technique. It creates as many trees on the subset of the data and combines 
                               the output of all the trees. In this way it reduces overfitting problem in 
                               decision trees and also reduces the variance and therefore improves the 
                               accuracy. Random Forest works well with both categorical and continuous 
                               variables. It also can automatically handle missing values. However, 
                               Random Forest creates a lot of trees (unlike only one tree in case of 
                               decision tree) and combines their outputs. To do so, this algorithm 
                               requires much more computational power and resources. It also requires 
                               much more time to train as compared to decision trees as it generates 
                               a lot of trees."
                                 ),
                                 tabPanel("Model Fitting",
                                          
                                 )
                      ),
             ),
             
             
             tabPanel("Data")
             )
        ))