#Script to plot SOI data from <https://www.ncdc.noaa.gov/teleconnections/enso/indicators/soi/data.csv>

library(ggplot2)
library(dplyr)

soi<-read.csv2('https://www.ncdc.noaa.gov/teleconnections/enso/indicators/soi/data.csv', header = T, skip=1,sep = ',')
soi$soi<-as.numeric(soi$Value)
soi$year<-substring(as.character(soi$Date),1, 4)
soi$month<-substring(as.character(soi$Date),5, 6)
soi$date<-as.Date(paste0(soi$year,'-',soi$month,'-01'),format='%Y-%m-%d')
soi$enso<-ifelse(soi$soi<=0,'El Niño','La Niña')


soi<-soi%>%filter(date>='2000-01-01')
ggplot(soi,aes(x=date,y=soi,fill=enso))+geom_bar(stat = 'identity')+
  theme_bw()+
  xlab(NULL)+ylab('Índice de Oscilação Sul (SOI)')+  
  theme(legend.title=element_blank())+
  scale_x_date(expand = c(0, 0)) +
  annotate("rect", xmin = as.Date('2015-05-01'), xmax = as.Date('2016-05-01'), ymin = -3, ymax = 3,
                                                              alpha = .2,fill = "red")+
  annotate("rect", xmin = as.Date('2020-05-01'), xmax = as.Date('2021-05-01'), ymin = -3, ymax = 3,
           alpha = .2,fill = "cyan")
ggsave('figures/soi_2000.jpg')
  
