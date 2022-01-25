library(tidyverse)
library(readr)
library(sf)
library(rnaturalearth)
Monde<-rnaturalearth::ne_countries(scale = 50, type = "countries",returnclass = "sf")
DonneesAu4MAI<-readr::read_csv("querywikidata4mai2020.csv")
head(DonneesAu4MAI$coordinates)
DF<-DonneesAu4MAI%>%mutate(tmp=gsub("\\)","",gsub("Point\\(","",coordinates)))%>%
  separate(col = tmp,into=c("lon","lat"),sep = " ")
DF$lat<-as.numeric(DF$lat)
DF$lon<-as.numeric(DF$lon)

DF %>%
  ggplot()+
  geom_sf(data=Monde,colour="black",fill="white")+
  stat_bin_2d(aes(lon,lat),binwidth = c(2,1.5))+
  scale_fill_viridis_c()+
  theme(panel.background = element_rect(fill="lightblue"),
        legend.position="top")


## france
