
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
dataset <- list('Upload a file'=c(1))
shinyUI(fluidPage(
  
  # Application title
  titlePanel(list(img(src="upatrasLogo.jpg",height="150", width="150"),
                  "Computing ROC curve"),"Compute ROC curve"),
  
  navlistPanel(
    tabPanel("Help",list(
      h3("Aim:"),h4("The aim of this web application is to compute the ROC curve of
a measured variable and a target (two-state) variable provided by the user. It also 
provides the sensitivity and specificity for all the available threshold values together
with their corresponding bootstrap confidence intervals following Carpenter and Bithell (2000)."),
      h5("James Carpenter and John Bithell (2000) “Bootstrap condence intervals: when, which, what? 
         A practical guide for medical statisticians”. Statistics in Medicine 19, 1141–1164."),
      h3("User guide:"),
      h4("You need to follow the steps in the left-side panel in order to conduct the ROC analysis. 
         At first the selected data file must be uploaded to the application that contains the binary
         target variables and the continuous measured variables that we want to identify the optimal
         threshold.",br(),"A summary of all the variables included in the dataset is also available 
         in `Show Summary`. Raw data can be examined in the `Show Data` tab.",br(),"After data has been
         loaded, the target variable and the measured variable must be chosen in `Select Variables` before 
         the ROC Analysis is conducted in `Compute ROC Curve` tab."))),
    tabPanel("Load Data",list(h4("The application can accept datafiles in CSV or SPSS (sav) format."),fluidRow(radioButtons('filetype', 'Choose filetype',
                                               c(CSV='csv',
                                                 SPSS='spss'),
                                               'csv'),
                                  
                                  fileInput('file1', 'Choose File',
                                            accept=c('text/csv', 'text/comma-separated-values,text/plain','application/spss-sav',
                                                     '.csv','.sav')),
                                  tags$hr(),
                                  conditionalPanel(
                                    condition="input.filetype == 'csv'",
                                    checkboxInput('header', 'Header', TRUE)  
                                    ,
                                    
                                    radioButtons('sep', 'Separator',
                                                 c(Comma=',',
                                                   Semicolon=';',
                                                   Tab='\t'),
                                                 ','),
                                    radioButtons('quote', 'Quote',
                                                 c(None='',
                                                   'Double Quote'='"',
                                                   'Single Quote'="'"),
                                                 '"')#,
                                    #submitButton("Load Data")
                                  )
    ))),
    tabPanel("Show Summary",verbatimTextOutput("summary")),
    tabPanel("Show data",dataTableOutput("allData")),
    tabPanel("Select Variables",
             selectInput(inputId = "targetVar",
                         label = "Target Variable",
                         choices=names(dataset)),
             selectInput(inputId = "measureVar",
                         label = "Measure Variable",
                         choices=names(dataset)),
             
             #fluidRow( 
             #   
             # )
             #actionButton("go", "Compute ROC"),
             #plotOutput("plotROC")
             tableOutput("tableDataROC")
    ),
    tabPanel("Compute ROC Curve",textOutput("outText"),plotOutput("plotROC"),tableOutput("tableROC")
             #tabPanel("Compute ROC Curve",
    )
    
    
  )
)
)

#   # Sidebar with a slider input for number of bins
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("bins",
#                   "Number of bins:",
#                   min = 1,
#                   max = 50,
#                   value = 30)
#     ),
# 
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotOutput("distPlot")
#     )
#   )
# ))
