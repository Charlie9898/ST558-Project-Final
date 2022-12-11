library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(rstatix)
library(rsample)
library(caret)
library(Metrics)

shinyServer(function(input, output, session) {
  # Subset the data for EDA
  getData <- reactive({
    if(input$year=="LT10") {newData <- dataset %>% filter(Years <10)} 
    else {newData <- dataset %>% filter(Years >=10)}
    })
  
  # EDA plots
  output$EDAplot = renderPlot({
    newData <- getData()
    ## Select plot type for different analysis
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

  output$EDAtable = renderTable({
    newData <- getData()
    
    if (input$SummaryType=="DS") {
      tab <- data.frame(summary(newData %>% select(input$ysummary)))[,-1]
      names(tab) = c("Var","Summary Statistics")
      tab
    }
    else { ## find the outlier in terms of the selected variable
      tab <- newData %>% identify_outliers(input$ysummary)
      if (nrow(tab)==0) {print("No extreme value or outlier found for this variable.")}
      else {tab}
    }
  })
  # Initialize V to save the training set and test set
  v = reactiveValues(data = NULL)
  
  observeEvent(input$FitModel,{
    set.seed(123)
    split = initial_split(dataset,(1-input$DataSplit))
    v$dat_train = training(split)
    v$dat_test = testing(split)
    
    ## Store the model formula string
    pred=c()
    for (i in 1:length(input$predictor)) {pred = paste0(pred,"+",input$predictor[i])}
    
    ## Fit the models
    mod_lm = lm(paste0("Salary~",pred),data = v$dat_train)
    
    set.seed(123)
    grid = expand.grid(cp = input$cp)
    trctrl = trainControl(method = "cv", number = input$xval)
    mod_CART = train(as.formula(paste0("Salary~",pred)), data = v$dat_train, 
                     method = "rpart", trControl=trctrl,tuneGrid = grid)
    
    set.seed(123)
    grid = expand.grid(mtry = input$mtry)
    trctrl = trainControl(method = "cv", number = input$CV)
    mod_RF = train(as.formula(paste0("Salary~",pred)), data = v$dat_train,
                   method = "rf",trControl=trctrl,tuneGrid = grid)
    
    output$TrainRMSE = renderTable({
      round(data.frame(LinearModel = sqrt(mean(mod_lm$residuals^2)),
                 CART = RMSE(predict(mod_CART,newdata = v$dat_train),v$dat_train$Salary),
                 RandomForest = RMSE(predict(mod_RF,newdata = v$dat_train),v$dat_train$Salary)),3)
    })
    
    ## Render output summaries
    output$LMTrain = renderPrint({print(summary(mod_lm))})
    output$CARTTrain = renderPlot({plot(varImp(mod_CART))})
    output$RFTrain = renderPlot({plot(varImp(mod_RF))})
    
    ## Model validation on the test set
    pred_lm = predict(mod_lm,newdata = v$dat_test)
    pred_CART = predict(mod_CART,newdata = v$dat_test)
    pred_rf = predict(mod_RF,newdata = v$dat_test)
    
    ## Render test RMSE
    output$TestRMSE = renderTable({
      round(data.frame(LinearModel = RMSE(pred_lm,v$dat_test$Salary),
                       CART = RMSE(pred_CART,v$dat_test$Salary),
                       RandomForest = RMSE(pred_rf,v$dat_test$Salary)),3)
    })
  })
  
    # Prediction model
  observeEvent(input$PredBut,{
    ## Initial the model formula
    pred=c()
    for (i in 1:length(input$predictor)) {pred = paste0(pred,"+",input$predictor[i])}
    
    ## Refit the corresponding model
    if (input$PredMod=="mod_lm") {mod_pred = lm(paste0("Salary~",pred),data = v$dat_train)} 
    else if (input$PredMod=="mod_CART") {
      set.seed(123)
      grid = expand.grid(cp = input$cp)
      trctrl = trainControl(method = "cv", number = input$xval)
      mod_pred = train(as.formula(paste0("Salary~",pred)), data = v$dat_train, 
                       method = "rpart", trControl=trctrl,tuneGrid = grid)
    }
    else {
      set.seed(123)
      grid = expand.grid(mtry = input$mtry)
      trctrl = trainControl(method = "cv", number = input$CV)
      mod_pred = train(as.formula(paste0("Salary~",pred)), data = v$dat_train,
                     method = "rf",trControl=trctrl,tuneGrid = grid)
    }
    
    ## Predict the value
    dat_new = data.frame(AtBat = input$AtBat, Hits = input$Hits, HmRun = input$HmRun, Runs = input$Runs,
                         RBI = input$RBI, Walks = input$Walks, Years = input$Years, CAtBat = input$CAtBat,
                         CHits = input$CHits, CHmRun = input$CHmRun, CRuns = input$CRuns, CRBI = input$CRBI,
                         CWalks = input$CWalks, League = input$League, Division = input$Division,
                         PutOuts = input$PutOuts, Assists = input$Assists, Errors = input$Errors, 
                         NewLeague = input$NewLeague)
    
    output$prediction = renderPrint({predict(mod_pred,newdata = dat_new)})
  })
  
  # Subset dataset for Data panel
  SubsetData <- reactive({
    if(input$SubsetRows=="5-") {newData <- dataset %>% filter(Salary <5)} 
    else if (input$SubsetRows=="5-6")
    {newData <- dataset %>% filter(Salary >=5 & Salary <6)}
    else if (input$SubsetRows=="6-7")
    {newData <- dataset %>% filter(Salary >=6 & Salary <7)}
    else {newData <- dataset %>% filter(Salary >7)}
    
    newData = select(newData,input$SubsetColumns)
  })
  # Render subset data
  output$DataOutput = renderDataTable({
    subDat = SubsetData()
    })
  
  # save the file
  observe({
    volumes <- c("UserFolder"="D:/")
    shinyFileSave(input, "save", roots=volumes, session=session)
    fileinfo <- parseSavePath(volumes, input$save)
    data <- SubsetData()
    if (nrow(fileinfo) > 0) {
      write.xlsx(data, as.character(fileinfo$datapath))
    }
  })
})
