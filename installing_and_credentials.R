# #Terminal-----------
# sudo apt install  libudunits2-dev libgdal-dev libgeos-dev libproj-dev python3.8-venv



#Istall packages-------------------
# install.packages("s2")
# install.packages("sf")
# install.packages("leafem")
# install.packages("reticulate")
# install.packages("R6")
# install.packages("processx")
# install.packages("rgee")
# install.packages("googledrive")


#Load packages------------
library(rgee)
library(googledrive)

# #Install python environment
# ee_install(py_env = "rgee") # It is just necessary once!
# ee_check()
# #Credentials
# ee_Initialize(email = 'prof.tiago.gandra@gmail.com', drive = TRUE)

#Testing-------------
library(rgee)
ee_Initialize()
srtm <- ee$Image("USGS/SRTMGL1_003")
viz <- list(
  max = 4000,
  min = 0,
  palette = c("#000000","#5AAD5A","#A9AD84","#FFFFFF")
)
Map$addLayer(
  eeObject = srtm,
  visParams =  viz,
  name = 'SRTM',
  legend = TRUE
)
