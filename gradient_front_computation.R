#Slope and treshold for fronts
rm(list=ls())
library('raster')
library('sf')
library('exactextractr')

sessionInfo()

study_site<-read_sf("input_data/Area_de_estudo.shp")


sst<-stack('input_data/sst_2015_v2.tif')

study_site<-st_transform(study_site,crs=st_crs(sst))
mask<-rasterize(study_site,sst,field='id',background=0)

plot(mask)


#2015----------------
#Carregando imagens
sst<-stack('input_data/sst_2015_v2.tif')
#Função para filtro espacial de passa-baixa (moda)
fun <- function(x){
  tab <- table(x)
  # I am using the first value here, maybe you want to use the mean, 
  # if 2 or more values occur equally often.
  names(tab)[which.max(tab)][1]
}

#Organizando as datas
datei<-as.Date('2015-05-01')
datef<-as.Date('2016-05-01')
dates<-seq.Date(datei, datef, by='week' )


#Loop para uma imagem por semana-----------
sl<-list()
fl<-list()
i=12

time0<-Sys.time()
for(i in 1:nlayers(sst)){
  time1<-Sys.time()
  print(i)
  s<-terrain(sst[[i]], opt='slope',unit='radians')
  s<-tan(s)*1000
  #limiar para frentes
  f<-s>0.2
    f.focal <- focal(f, w=matrix(1,5,5), fun=fun)
  #removendo nodata
  # f[is.na(f[])]<-0
  sl[[i]] <- s
  fl[[i]] <- f.focal
  print(Sys.time()-time1)
  print(Sys.time()-time0)
}

slope2015<-stack(sl)*mask
fronts2015<-stack(fl)*mask
names(slope2015)<-paste0('s',dates)
names(fronts2015)<-paste0('s',dates)

# plot(slope2015)
plot(fronts2015)

#Soma de frentes por pixel--------
frontn2015<-sum(fronts2015)
plot(frontn2015)


#Write rasters---------
writeRaster(slope2015,'output_data/slope2015.tif',overwrite=T)
writeRaster(fronts2015,'output_data/fronts2015.tif',overwrite=T)
writeRaster(frontn2015,'output_data/frontn2015.tif',overwrite=T)


#Get front areas
results2015<-as.data.frame(t(exact_extract(fronts2015,study_site,'sum')))
results2015$date<-dates
results2015$ENSO<-'El Niño'


#2020----------------
#Carregando imagens
sst<-stack('input_data/sst_2020_v3.tif')
sst


#Organizando as datas
datei<-as.Date('2020-05-01')
datef<-as.Date('2021-05-01')
dates<-seq.Date(datei, datef, by='week' )


#Loop para uma imagem por semana-----------
sl<-list()
fl<-list()

time0<-Sys.time()
for(i in 1:nlayers(sst)){
  time1<-Sys.time()
  print(i)
  s<-terrain(sst[[i]], opt='slope',unit='radians')
  s<-tan(s)*1000
  #limiar para frentes
  f<-s>0.2
  f.focal <- focal(f, w=matrix(1,5,5), fun=fun)
  #removendo nodata
  # f[is.na(f[])]<-0
  sl[[i]] <- s
  fl[[i]] <- f.focal
  
  print(Sys.time()-time1)
  print(Sys.time()-time0)
}

plot(mask)
slope2020<-stack(sl)*mask
fronts2020<-stack(fl)*mask
names(slope2020)<-paste0('s',dates)
names(fronts2020)<-paste0('s',dates)

plot(slope2020)
plot(fronts2020)

#Soma de frentes por pixel--------
frontn2020<-sum(fronts2020)*mask
plot(frontn2020)


#Write rasters---------
writeRaster(slope2020,'output_data/slope2020.tif',overwrite=T)
writeRaster(fronts2020,'output_data/fronts2020.tif',overwrite=T)
writeRaster(frontn2020,'output_data/frontn2020.tif',overwrite=T)

#Get front areas
results2020<-as.data.frame(t(exact_extract(fronts2020,study_site,'sum')))
results2020$date<-dates
results2020$ENSO<-'La Niña'

save(slope2015,slope2020,fronts2015,fronts2020,results2015,results2020,file='output_data/fronts.Rda')

