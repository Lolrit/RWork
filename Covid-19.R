#libraries
library(covid19.analytics)
library(dplyr)
library(lubridate)
library(prophet)
library(plotly)

#covid-cases

agg <- covid19.data(case = 'aggregated')
tsc <- covid19.data(case = 'ts-recovered')  
tsc1 <- covid19.data(case = 'ts-recovered')  
tsa <- covid19.data(case = 'ts-ALL')

report.summary(Nentries = 10, graphical.output = T)
tots.per.location(tsc,geo.loc = 'INDIA')

growth.rate(tsc,geo.loc = 'INDIA')
totals.plt(tsa, c('INDIA'))

live.map(tsc)

generate.SIR.model(tsc,'INDIA')


#new work
{
tsc1<- tsc1 %>% filter(Lat == 20.593684)
tsc1 <- data.frame(t(tsc1)) 
tsc1 <- cbind(rownames(tsc1), data.frame(tsc1))
colnames(tsc1) <- c('Date','Confirmed')
tsc1 <- tsc1[-c(1:4),]
tsc1$Date <- ymd(tsc1$Date)
tsc1$Confirmed <- as.numeric(tsc1$Confirmed)
}
str(tsc1)
#plot
plot1 <- qplot(Date, Confirmed, data = tsc1,
      main = "Covid Confirmed cases in India")
plot1_inter <- ggplotly(plot1)
ds <- tsc1$Date
y <- tsc1$Confirmed
dfc <- data.frame(ds,y)

#forecast
m <- prophet(dfc)

#prediction
future <- make_future_dataframe(m, periods = 60) 
fcast <- predict(m, future)

# plotting forecast
a <- plot(m,fcast)
dyplot.prophet(m,fcast)
aint <- ggplotly(a)
aint

#forecast_components
prophet_plot_components(m,fcast)

#model_performance
pred <- fcast$yhat[1:234]
actual <- m$history$y
plot(actual,pred)
abline(lm(pred~actual), col = 'blue')
summary(lm(pred~actual))
