library(shiny)
library(datasets)

# do these before the shinyServer call, that is, only once
dat <- read.csv( "/Users/heimannrichard/Google Drive/R Code/regression_shiny/columbus.csv")

# Define server logic 
shinyServer(function(input, output) {

  # Return the requested dataset
  datasetInput <- reactive({
    switch(input$dataset,
           "CRIME" = CRIME,
           "INCOME" = INCOME,
          )
  })
  
  # Generate a summary of the dataset
  output$summary <- renderPrint({
    dataset <- datasetInput()
    summary(dataset)
  })
  

  

output$Fit <- renderPlot({
  if(input$order=="lin"){
    mod <- lm(dat$CRIME~dat$INC, na.action = na.exclude)
    betas <- coefficients(mod)
    plot(dat$INC, dat$CRIME)
    abline(mod)
    }
  if(input$order=="quad"){
    mod <- lm(dat$CRIME~dat$INC+I(dat$INC^2), na.action = na.exclude)
    betas <- coefficients(mod)
    xx <- seq(min(dat$INC), max(dat$INC), len=50)
    yy <- betas[1] + betas[2] * xx + betas[3]*xx*xx
    plot(dat$INC, dat$CRIME)
    lines(xx,yy)
    } 
    })    

output$Outs <- renderPlot({
  if(input$order=="lin"){
    mod <- lm(dat$CRIME~dat$INC, na.action = na.exclude)
    resid <- abs(mod$residuals)
    predicted <- abs(mod$fitted.values)
    dat2 <- cbind(dat, resid)
    dat2a <- cbind(dat2, predicted)
    dat3 <- dat2a[order(dat2$resid, decreasing=T),]
      plot(dat3$predicted, dat3$resid, 
        xlab="Predicted", ylab="Abs(Resid)")
      points(dat3$predicted[1:input$int], dat3$resid[1:input$int], col="red", pch=19)
    }
  if(input$order=="quad"){
    mod <- lm(dat$CRIME~dat$INC+I(dat$INC^2), na.action = na.exclude)
    resid <- abs(mod$residuals)
    predicted <- abs(mod$fitted.values)
    dat2 <- cbind(dat, resid)
    dat2a <- cbind(dat2, predicted)
    dat3 <- dat2a[order(dat2$resid, decreasing=T),]
      plot(dat3$predicted, dat3$resid, 
        xlab="Predicted", ylab="Abs(Resid)")
      points(dat3$predicted[1:input$int], dat3$resid[1:input$int], col="red", pch=19)
    }    
    
  })  
  
  output$regsum <- renderPrint({
    mod <- lm(dat$CRIME~dat$INC+I(dat$INC^2))
    summary(mod)
  })

})