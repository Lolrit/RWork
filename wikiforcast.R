library(wikipediatrend)
library(plotly)
library(prophet)
library(ggplot2)
library(grid)
library(ggplotify)

TB <- wp_trend( page = "Indian_Railways",
                from = "2013-01-01",
                to = "2020-10-13" )
TB


qplot(date,
      views,
      data = TB)
summary(TB)

TB$views[TB$views == 0] <- NA
TB

#removing missing data

ds <- TB$date
y <- log(TB$views)
df <- data.frame(ds,y)
qplot(ds,y,data=df)

#Prophet

m <- prophet(df)

#make_future_predict

future<-make_future_dataframe(m, periods = 365)
tail(future)
fcast <- predict(m,future)
tail(fcast[c('ds','yhat','yhat_upper','yhat_lower')])

#plotting

test <- plot(m, fcast)
prophet_plot_components(m, fcast)

test1 <- as.ggplot(test)
ggplotly(test)
