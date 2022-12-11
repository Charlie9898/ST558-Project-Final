# ST558-Project-Final
## Introductrion
This project includes an R Shiny APP that can be used for predicting the baseball player's salary using several statistical models. The models used in this project are multiple linear regression model, regression tree model, and random forest model.  
The data used in this app is the `Hitters` dataset from the ISLR2 library in R. The dataset can be found in `James et al`. 
This app contains four pages, each page contain several tabs.  
The first `About` page provides an overview about the purpose of the app, the data used in the app, and other related information.  
The second `Data Exploration` page provides tools to explore the input data. Summary statistics and plots can be developed for the dataset.  
The third `Modeling` page provides the three statistical models used to predict salary. The modeling information, model fiting processes, model validation and prediction processes can be found in sub-tabs.  
The last `Data` page provides a toolbox to view, subset, and save the dataset.  
  
Note: 
* In the `Data Exploration` page, users can subset rows of the dataset based on the `Years` variable, and the following data exploration is based on the subset of the dataset.  
* In the `Modelling` page, Model Fitting tab, all of the three models are fitted based on the predictors selected in the `Select Predictor` selection box. The model prediction function in the `Prediction` tab will also includes the selected predictors and the prefitted model in the `Model Fitting` tab.  
* The `Data` page can save the dataset shown in the main panel on the right. The default path is `D:/`.  
  

## List of Packages
This Shiny APP requires multiple R packages. Below are the list of packages required.  
* `shiny`: An R package makes it easy to build interactive web apps straight from R.  
* `ISLR2`: Contains the raw dataset.  
* `ggplot2`: A package for advanced plots.  
* `rpart`: For classification models.  
* `shinyFiles`: For file access.  
* `xlsx`: For manipulating Excel files.  
* `dplyr`: For working with data frame like objects, both in memory and out of memory.  
* `stringr`: Provides a cohesive set of functions designed to make working with strings as easy as possible.  
* `rstatix`: Contains helper functions for identifying univariate and multivariate outliers.  
* `rsample`:For split the dataset into training set and test set.  
* `caret`: Contains functions for training and plotting classification and regression models.  
* `Metrics`: For obtaining the RMSE values of the models.  
  
## Code for Installing Packages
Use the following code to install the required packages in R.
```{r}
install.packages(c("shiny","ISLR2","ggplot2","rpart","shinyFiles","xlsx","dplyr",
                 "stringr","rstatix","rsample","caret","Metrics"))
```
## Run the App
Use the following code to run the APP.
```{r}
shiny::runGitHub("ST558-Project-Final","Charlie9898")
```
