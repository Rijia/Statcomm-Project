library(shiny)
shinyUI(fluidPage(
  titlePanel("Income Inequality by State"),
  sidebarLayout(
    sidebarPanel(
      helpText("Create line plots of gini index for different Year"),
      
      sliderInput("Year",
                  "Choose an Year",
                  min=2005,
                  max=2014,
                  value=2005)
      ),
      mainPanel(
        plotOutput("plot")
))))
