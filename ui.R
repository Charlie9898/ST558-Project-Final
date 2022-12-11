library(shiny)
library(ISLR2)
library(ggplot2)
library(rpart)
library(shinyFiles)
library(xlsx)
# Preprocessing the dataset, omit the NA values and log-transform the Salary variable for normality
data(Hitters)
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
                      
                      img(src = paste0("https://images.squarespace-cdn.com/content/v1/",
                                       "5ff2adbe3fe4fe33db902812/1611294680091-25SIDM9AHA8ECIFFST23/",
                                       "Screen+Shot+2021-01-21+at+11.02.06+AM.png?format=750w"),
                          height = 315, width = 188)),
             
             
             tabPanel("Data Exploration",
                      sidebarPanel(
                          h3("This page provides a data exploration tool"),br(),
                          
                          "Subset Data:",
                          # For illustration purpose, subset rows based on Year interval
                          # Can also add additional rules for row subset
                          selectizeInput("year", "Year", choices = c("<10"="LT10",
                                                                     ">=10"="GE10")),
                          
                          h3("Data Exploration Plot"),
                          # select types of outputs for EDA
                          radioButtons(inputId = "PlotType",label = "Select the Plot Type",
                                       choices = c("Scatter Plot (X vs Y)"="SP",
                                                   "Histogram (Y)"="Hist",
                                                   "By Group Bar Chart (Average of Y by group)"="BC")),
                         
                          # Select variables based on plot types
                          conditionalPanel(condition = "input.PlotType=='SP'",
                                           selectInput('xsp', 'X', names(dataset)[c(-14,-15,-20)]),
                                           selectInput('ysp', 'Y', names(dataset)[c(-14,-15,-20)], 
                                                       names(dataset)[[19]])),
                          
                          conditionalPanel(condition = "input.PlotType=='Hist'",
                                           selectInput('yhist', 'Y', names(dataset)[c(-14,-15,-20)], 
                                                       names(dataset)[[19]])),
                          
                          conditionalPanel(condition = "input.PlotType=='BC'",
                                           selectInput('ybc', 'Y', names(dataset)[c(-14,-15,-20)], names(dataset)[[19]]),
                                           selectInput('groupbc', 'Variable to Group by', 
                                                       c(names(dataset)[[14]],names(dataset)[[15]],
                                                         names(dataset)[[20]]), names(dataset)[[14]])),
                          
                          h3("Data Exploration Table"),
                          # For the table output, can either show the summary statistics or identify the extreme values
                          radioButtons(inputId = "SummaryType",label = "Select the Summary Type",
                                       choices = c("Descriptive Statistics"="DS",
                                                   "Extreme Observations"="EO")),
                          
                          # Select target variable for table summary
                          selectInput('ysummary', 'Y', names(dataset)[c(-14,-15,-20)], names(dataset)[[19]]),
                          br(),br(),br(),br(),br(),br()
                        ),
                      mainPanel(
                        plotOutput("EDAplot"),
                        tableOutput("EDAtable")
                        )),
            
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
                                          sidebarLayout(
                                            sidebarPanel(
                                              # set the training set and test set ratio
                                              sliderInput("DataSplit","Portion for Test Set",0.01,0.99,0.2,step=0.01),
                                              br(),
                                              # select predictors for the models
                                              tags$div(align = 'left', 
                                                       class = 'multicol', 
                                                       checkboxGroupInput("predictor","Select Predictors", 
                                                                          choices = names(dataset)[-19],
                                                                          selected = names(dataset)[1:4],inline   = T)
                                                       ),
                                              br(),
                                              h4("Tuning parameters for CART model"),
                                              # choose the CV folds for CART model
                                              sliderInput("xval","CV folds",2,10,5,step=1),
                                              # choose the CP value for CART model
                                              sliderInput("cp","Complexity Parameter",0,1,0,step=0.05),
                                              br(),
                                              h4("Tuning parameters for Random Forest model"),
                                              # choose the CV folds for RF model
                                              sliderInput("CV","CV folds",2,10,5,step=1),
                                              # choose the mtry parameter for RF model
                                              sliderInput("mtry","No. of random predictors",1,19,4,step=1),
                                              
                                              # Fit all models button
                                              actionButton("FitModel",strong("Fit Models"))
                                            ),
                                            mainPanel(
                                              # Print the fitting and testing results
                                              h4("Fitting Results for Training Set"),
                                              h5("Training RMSE"),
                                              tableOutput("TrainRMSE"),
                                              br(),
                                              h5("Multiple Linear Regression Model"),
                                              verbatimTextOutput("LMTrain"),
                                              br(),
                                              h5("CART Model"),
                                              plotOutput("CARTTrain"),
                                              br(),
                                              h5("Random Forest Model"),
                                              plotOutput("RFTrain"),
                                              br(),
                                              h4("Fitting Results for Test Set"),
                                              "Test RMSE",
                                              tableOutput("TestRMSE")
                                            ))),
                                 tabPanel("Prediction",
                                          sidebarLayout(
                                            sidebarPanel(
                                              # choose the model for prediction
                                              selectInput("PredMod","Select Prediction Model",
                                                          c("Linear Model" = "mod_lm",
                                                            "CART Model" = "mod_CART",
                                                            "Random Forest Model" = "mod_RF")),
                                              br(),
                                              h4("Input the values for the predictors"),
                                              # only show the newdata inputs for variables selected in Model Fitting panel
                                              conditionalPanel("input.predictor.includes('AtBat')",
                                                               numericInput("AtBat","AtBat",NA)),
                                              conditionalPanel("input.predictor.includes('Hits')",
                                                               numericInput("Hits","Hits",NA)),
                                              conditionalPanel("input.predictor.includes('HmRun')",
                                                               numericInput("HmRun","HmRun",NA)),
                                              conditionalPanel("input.predictor.includes('Runs')",
                                                               numericInput("Runs","Runs",NA)),
                                              conditionalPanel("input.predictor.includes('RBI')",
                                                               numericInput("RBI","RBI",NA)),
                                              conditionalPanel("input.predictor.includes('Walks')",
                                                               numericInput("Walks","Walks",NA)),
                                              conditionalPanel("input.predictor.includes('Years')",
                                                               numericInput("Years","Years",NA)),
                                              conditionalPanel("input.predictor.includes('AtBat')",
                                                               numericInput("CAtBat","CAtBat",NA)),
                                              conditionalPanel("input.predictor.includes('CAtBat')",
                                                               numericInput("CHits","CHits",NA)),
                                              conditionalPanel("input.predictor.includes('CHmRun')",
                                                               numericInput("CHmRun","CHmRun",NA)),
                                              conditionalPanel("input.predictor.includes('CRuns')",
                                                               numericInput("CRuns","CRuns",NA)),
                                              conditionalPanel("input.predictor.includes('CRBI')",
                                                               numericInput("CRBI","CRBI",NA)),
                                              conditionalPanel("input.predictor.includes('CWalks')",
                                                               numericInput("CWalks","CWalks",NA)),
                                              conditionalPanel("input.predictor.includes('League')",
                                                               textInput("League","League (A or N)",NA)),
                                              conditionalPanel("input.predictor.includes('Division')",
                                                               textInput("Division","Division (E or W)",NA)),
                                              conditionalPanel("input.predictor.includes('PutOuts')",
                                                               numericInput("PutOuts","PutOuts",NA)),
                                              conditionalPanel("input.predictor.includes('Assists')",
                                                               numericInput("Assists","Assists",NA)),
                                              conditionalPanel("input.predictor.includes('Errors')",
                                                               numericInput("Errors","Errors",NA)),
                                              conditionalPanel("input.predictor.includes('NewLeague')",
                                                               textInput("NewLeague","NewLeague (A or N)",NA)),
                                              
                                              # button for predict the results
                                              actionButton("PredBut",strong("Predict"))
                                            ),
                                            mainPanel(
                                              h4("Prediction Result:"),
                                              "Salary:",
                                              verbatimTextOutput("prediction")
                                            )),
                                          )),
             ),

             tabPanel("Data",
                      sidebarPanel(
                        h3("Subset Rows"),
                        # subset rows based on salary intervals
                        selectizeInput("SubsetRows", "Salary", choices = c("Salary<5"="5-",
                                                                         "5<=Salsry<6"="5-6",
                                                                         "6<=Salsry<7"="6-7",
                                                                         "Salary>=7"="7+")),
                        h3("Subset Columns"),
                        # subset columns by selecting variables
                        checkboxGroupInput("SubsetColumns","Select Variables", 
                                           choices = names(dataset),
                                           selected = names(dataset)[1:4],inline = T),
                        # Save the subset of dataset as XLSX file
                        shinySaveButton("save", "Save file", "Save file as ...", filetype=list(xlsx="xlsx"))
                      ),
                      mainPanel(
                        dataTableOutput("DataOutput")
                      )))))