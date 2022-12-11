# ST558-Project-Final
## Introductrion

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
runGitHub("ST558-Project-Final","Charlie9898")
```
