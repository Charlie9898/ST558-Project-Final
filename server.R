library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(rstatix)

shinyServer(function(input, output, session) {
  
  getData <- reactive({
    if(input$year=="LT10") {newData <- dataset %>% filter(Years <10)} 
    else {newData <- dataset %>% filter(Years >=10)}
    })
  
  
  output$plot = renderPlot({
    newData <- getData()
    
    if (input$PlotType=="SP") {
      g <- ggplot(newData, aes_string(x = input$xsp, y = input$ysp))
      g + geom_point()
    } else if (input$PlotType=="Hist") {
      g <- ggplot(newData, aes_string(x = input$yhist))
      g + geom_histogram()
    }
    else {
      # need to group by a new dataframe then plot it.
      dat = newData %>% group_by_(input$groupbc) %>% summarise(avg = mean(get(input$ybc)))
      g <- ggplot(dat, aes_string(x = input$groupbc, y = dat$avg))
      g+geom_bar(stat="identity")+ylab("Average Value of Y")
    }
    })

  output$table = renderTable({
    newData <- getData()
    
    if (input$SummaryType=="DS") {
      tab <- data.frame(summary(newData %>% select(input$ysummary)))[,-1]
      names(tab) = c("Var","Summary Statistics")
      tab
    }
    else {
      tab <- newData %>% identify_outliers(input$ysummary)
      if (nrow(tab)==0) {print("No extreme value or outlier found for this variable.")}
      else {tab}
    }
  })
  
})
