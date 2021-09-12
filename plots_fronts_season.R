#Plot fronts by week------------
library(dplyr)
library(ggplot2)
library(raster)
library(scales)
library(stringr)

rm(list=ls())
load('output_data/fronts.Rda')
results<-rbind(results2015,results2020)
results<-results%>%mutate(month=as.numeric(format(date,"%m")))
results[13,]
results$season<-'s'
results[which(results$month%in%c(4,5,6)),]$season<-'Outono'
results[which(results$month%in%c(7,8,9)),]$season<-'Inverno'
results[which(results$month%in%c(10,11,12)),]$season<-'Primavera'
results[which(results$month%in%c(01,02,03)),]$season<-'Verão'

results$season<-factor(results$season, levels=c("Outono",'Inverno','Primavera','Verão'))

unique(results$season)


ggplot(results,aes(x=date,y=V1,fill=season))+geom_bar(stat='identity')+
  facet_wrap(~ENSO,scales='free_x',ncol=1)+
  theme_bw()

ggplot(results,aes(x=season,y=V1*4000*4000/1000000,fill=ENSO))+geom_boxplot()+
  theme_bw()+
  xlab('Estação')+
  ylab('Área de Zonas Frontais (km²)')
ggsave('figures/boxplot_frentes_estacao.jpg')

results$date2<-as.Date(str_replace(as.character(results$date),'2015','2020'))
results$date2<-as.Date(str_replace(as.character(results$date2),'2016','2021'))

ggplot(results,aes(x=as.POSIXct(date2),y=V1*4000*4000/1000000,color=ENSO))+geom_smooth()+
  theme_bw()+
  scale_x_datetime(labels = date_format("%b"),breaks=date_breaks('1 months'))+
  xlab('Mês')+
  ylab('Área de Zonas Frontais (km²)')
ggsave('figures/smooth_frentes_mes.jpg')


