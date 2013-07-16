library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("MAP-HT Regression Analysis"),

  sidebarPanel(
    selectInput("order", "Model:",
      list( "Linear" = "lin",
            "Quadratic" = "quad")),
    
    

      selectInput("dataset", "Choose a dataset:", 
                  choices = c("CRIME", "INCOME")),

      br(),
      
    sliderInput("int", "Display Top N Outliers:", 
                min=1, max=50, value=5)
    

),

  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("Fit"))  ,
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Regression", verbatimTextOutput("regsum")),
      tabPanel("Outliers", plotOutput("Outs"))
      )
    )
  )
)