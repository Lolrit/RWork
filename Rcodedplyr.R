library('dplyr')
library('plotly')
flight1<-read.csv("C:/Users/Administrator/Documents/Databases/flights.csv")
flight1 %>%
  dplyr::filter(dest == "ORD") %>%
  dplyr::select(dep_delay,arr_delay,carrier)%>%
  dplyr::arrange(carrier)%>%
  filter(!is.na(dep_delay))%>%
  filter(!is.na(arr_delay))
p <- ggplot(flight1, aes(x=arr_delay, y=dep_delay, color=carrier)) + geom_jitter()
final<-ggplotly(p)
final
