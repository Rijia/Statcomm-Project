library(maps) #for creating geographical maps
library(mapdata) #contains basic data for ’maps’
library(maptools) #tools for handling spatial objects
library(mapproj) #for creating projected maps
library(ggplot2) #to create maps
library(gpclib) #general polygon clipper
library(RColorBrewer)
library(classInt)
library(reldist)
library(plyr)
library(shiny)
incomedata.1<-readRDS("incomedata.rds")
shinyServer(function(input,output){
  output$plot<-renderPlot({
    
  temp.data <- incomedata.1[which(incomedata.1$period==input$Year), ]
  gini.state.temp<-tapply(temp.data$ptotval,temp.data$gestfips,gini)
  temp.data$state.fips<-as.factor(temp.data$gestfips)
  levels(temp.data$state.fips)
  gini.state.temp<-data.frame(levels(temp.data$state.fips),gini.state.temp)
  colnames(gini.state.temp)<- c("state", "GINI")
  data(state.fips)
  gini.state.temp$GINI<-as.numeric(gini.state.temp$GINI)
  colors=brewer.pal(8,"Blues")
  #colors = c("#ff35c1","#e6009f","#d20091", "#bf0084", "#ab0076", "#970069", "#84005b", "#5d0040")
  gini.state.temp$colorBuckets <- as.numeric(cut(gini.state.temp$GINI, c(0.40, 0.45 ,0.46 ,0.47, 0.48, 0.49,0.50, 0.51, 1)))
  colorsmatched.temp <- gini.state.temp$colorBuckets[match(state.fips$fips, gini.state.temp$state)]
  map("state", col = colors[colorsmatched.temp], fill = TRUE, resolution = 0, lty = 0, projection = "polyconic")
  map("state", col = "Blue4", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2,  projection = "polyconic")
  Year<-as.character(1:2014)
  title(paste("Income Inequality by State in Year", substitute(a,list(a=Year[input$Year]))))
  leg.txt <- c("<0.45", "0.45-0.46", "0.46-0.47", "0.47-0.48","0.48-0.49","0.49-0.50","0.50-0.51", ">0.51")
  legend("bottomright",title="GINI Index", leg.txt,fill = colors,cex=0.60 )
  
})
})
