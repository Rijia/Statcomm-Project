load("/Users/rijiazou/Statcomm-Project/incomedata.1.Rda")
Inc<-incomedata.1
library(dplyr)
SVG.data<-summarise(group_by(Inc,period,cohort.factor),Mean=mean(ptotval),UB=quantile(ptotval,0.75),LB=quantile(ptotval,0.25))


Graph1 <- function(j) { # Define function to make the plot for a single parameter
  temp.data<-filter(SVG.data,period==j)
  # compute limits of y-axis (adding a bit of extra space)
  ymin <- min(temp.data$LB) - 0.2*min(temp.data$LB) 
  ymax <- max(temp.data$UB) + 0.2*max(temp.data$UB)
  
  # make an empty plot (no data or axes) with the right dimensions 
  plot(NULL, xlim = c(1,6), ylim = c(ymin, ymax), axes = FALSE,
       ylab = "", xlab = "",main=paste("Income distribution Year in",substitue(a,list(a=j))))
  
  # add faint dashed horizontal lines at the locations of the y-axis tickmarks
  abline(h = axTicks(side = 2), lty = 2, col = "lightgray", lwd = 0.75)
  

  # add the (LB,UB) intervals for each distribution and points for the means
  segments(x0 = 1:6, y0 = temp.data$LB, y1 = temp.data$UB, lwd = 3)
  points(1:6, temp.data$Mean, pch = 20, cex = 1.5)
  
  # add the axes and informative text below x-axis
  axis(side = 2)
  axis(side = 1, at = 1:6, labels = temp.data$cohort.factor, cex.axis = 0.8, padj =-.5)
}

library(animation)
ani.options(interval = 0.5, nmax = 9)
for (i in 2005:2013) {
  Graph1(i)
  ani.pause()
}


