
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(DT)
library(pROC)
#suppressMessages(library(pROC))
library(data.table)
library(ggplot2)

source("ComputeROC.R")



shinyServer(function(input, output,session) {
  
  data <- reactive({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    if (input$filetype=="spss"){
      library(foreign)
      read.spss(inFile$datapath,to.data.frame = T)
    } else {
      read.csv(inFile$datapath, header=input$header, sep=input$sep, quote=input$quote)
    }
  })
  
  observe({
    df <- data()
    
    if (!is.null(df)) {
      output$summary <- renderPrint(summary(data()) )
      updateSelectInput(session, 'targetVar', choices = names(df))
      updateSelectInput(session, 'measureVar', choices = names(df))
    }
  })
  
  observe({
    df <- data()
    
    if (input$targetVar%in%names(df) & input$measureVar%in%names(df) & 
        input$targetVar!=input$measureVar ){
      matData <- df[,c(input$targetVar,input$measureVar)]
      if (length(unique(matData[,1]))==2){
        output$tableDataROC <- renderTable(head(matData))
        outList <- ComputeROC(matData,input$measureVar,input$targetVar,numBootstraps=100)
        output$tableROC <- renderTable(as.data.frame(outList[[1]])) 
        output$plotROC <- renderPlot(outList[[2]])
        output$outText <- renderText("ROC successfully computed.")
      } else {
        output$outText <- renderText("Target variable must have only two levels.")
        output$plotROC <- renderPlot(NULL)
        output$tableROC <- renderTable(NULL)
      }
      
    } else {
      output$outText <- renderText("Data must be loaded and variables must be selected before computing the ROC curve.")
    }
    output$allData <- DT::renderDataTable(data())
    
  })

})
