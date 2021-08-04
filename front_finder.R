library(rgee)
library(RColorBrewer)
ee_Initialize()


bb=ee$Geometry$Rectangle(-58,-39,-38,-22)
pt = ee$Geometry$Point(-50,-32)

startDate = ee$Date('2020-01-01')
endDate = ee$Date('2021-01-01')

#Get image collection---------
modis<-ee$ImageCollection("NASA/OCEANDATA/MODIS-Aqua/L3SMI")

# #A function to mask out cloudy pixels.
# maskQuality<-map(function(image) {
#   # Select the QA band.
#   QA = image$select('StateQA')
#   # Get the internal_cloud_algorithm_flag bit.
#   internalQuality = getQABits(QA,8, 13, 'internal_quality_flag')
#   # Return an image masking out cloudy areas.
#   return image$updateMask(internalQuality$eq(0))
# })

#Filter image collection
sst<-modis$filterDate(startDate,endDate)$select(13)$
  map(function(image) {
    image$clip(bb)
  })$
  median()

#Set visualization parameters--------------

viz <- list(
  max = modis$max,
  min = 15,
  palette = rev(brewer.pal(5,"Spectral"))
)


#Add image
Map$centerObject(bb,zoom=5)
Map$addLayer(
    eeObject = sst,
    visParams =  viz,
    name = 'SST',
    legend = TRUE
)
