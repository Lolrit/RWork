library('reticulate')
library('plotly')

source_python("C:/Users/Administrator/Documents/pyscriptsforR/flights.py")
flights <- read_flights("C:/Users/Administrator/Documents/Databases/flights.csv")


temp <- ggplot(flights, aes(arr_delay, dep_delay, color=carrier)) + geom_jitter()
fig <- ggplotly(temp)
fig
