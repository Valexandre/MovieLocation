library(tidyverse)
library(data.table)

cpt_film <- DF %>% as.data.frame() %>% group_by(movie, movieLabel) %>% summarise(nb = n())

DF.geo <- DF %>% as.data.frame()

# leaflet
library(leaflet)
leaflet(padding = 0) %>%
  # addWMSTiles("Stamen.Toner", options=tileOptions(minZoom=11,maxZoom=13),attribution = "Insee (RP 1990 et 2013) / RATP-SNCF-Open Street Map-Wikipedia") %>%
  # addProviderTiles( "CartoDB.Positron", options=providerTileOptions(minZoom=11,maxZoom=13)) %>%
  setView(2.345899, 48.859467, zoom = 12) %>%
  addCircleMarkers(data = DF,
                   lng = ~lon, 
                   lat = ~lat, 
                   #radius = ~sqrt(P13_F65P) / 4,
                   weight = 0.5, 
                   stroke = T,
                   opacity = 50,
                   fill = T, 
                   #fillColor = ~pal.pct(pct_P13_F65P_P13_POP * 100), 
                   fillOpacity = 1,
                   group = "Part de mamies",
                   color = "black",
                   popup = ~ narrative_locationLabel,
                   labelOptions = labelOptions(noHide = F, textOnly = F))






## Initialisation 
pal.pct <- colorBin(palette = "Greens",domain = ~pct_P13_F65P_P13_POP * 100, bins = c(0, 6, 8, 12, 14, 18), pretty = F, reverse = F)
pal.evol.pct <- colorBin(palette = "RdBu",domain = ~diff_pct_P13_F65P_P13_POP_pct_DP90F65P_DP90T * 100,
                         bins = c(-7,-5,-4,-3,-2,-1, 0,1,2,3,4, 5 ,10), pretty = F, reverse = T)
popup <- ~paste0("<b>","<font size=4 color=black>" , nom_station,"</b>","</font>", "<br>",
                 "<b>", "% de mamies en 2013 : ", sprintf("%.1f%%",pct_P13_F65P_P13_POP * 100), "</b>", "<br>",
                 "% de mamies en 1990 : ", sprintf("%.1f%%",pct_DP90F65P_DP90T * 100), "<br>")
m <-
  leaflet(padding = 0) %>%
  addWMSTiles("Stamen.Toner", options=tileOptions(minZoom=11,maxZoom=13),attribution = "Insee (RP 1990 et 2013) / RATP-SNCF-Open Street Map-Wikipedia") %>%
  addProviderTiles( "CartoDB.Positron", options=providerTileOptions(minZoom=11,maxZoom=13)) %>%
  setView(2.345899, 48.859467, zoom = 12) %>%
  addCircleMarkers(data = STATIONS_data_indics.f,
                   lng = ~lon, 
                   lat = ~lat, 
                   radius = ~sqrt(P13_F65P) / 4,
                   weight = 0.5, 
                   stroke = T,
                   opacity = 50,
                   fill = T, 
                   fillColor = ~pal.pct(pct_P13_F65P_P13_POP * 100), 
                   fillOpacity = 1,
                   group = "Part de mamies",
                   color = "black",
                   popup = popup,
                   labelOptions = labelOptions(noHide = F, textOnly = F)) %>%
  addLegend("topright", 
            colors = brewer.pal(6,"Greens"),
            labels = c("< 6%","6% - 8%","8% - 10%","10% - 12%","12% - 14%","> 14%"),
            title = "Part de mamies",
            opacity = 1) %>%
  addCircleMarkers(data = STATIONS_data_indics.f,
                   lng = ~lon, 
                   lat = ~lat, 
                   radius = ~sqrt(P13_F65P) / 4,
                   weight = 0.5, 
                   stroke = T,
                   opacity = 50,
                   fill = T, 
                   fillColor = ~pal.evol.pct(diff_pct_P13_F65P_P13_POP_pct_DP90F65P_DP90T *100), 
                   fillOpacity = 1,
                   group = "Evolution 1990-2013",
                   popup = popup,
                   color = "black") %>%
  addLegend("bottomright",
            colors = c(rev(brewer.pal(6,"Reds")), brewer.pal(6,"Blues")),
            labels = rev(c("< -5 pts","-5/-4 pts","-4/-3 pts","-3/-2 pts","-2/-1 pts","-1/0 pt","0/+1 pt","+1/+2 pts","+2/+3 pts","+3/+4 pts","+4/+5 pts","> +5 pts" )),
            title = "Evolution 1990-2013",
            opacity = 1) %>%
  setMaxBounds( lng1 = min(STATIONS_data_indics.f$lon),
                lat1 = min(STATIONS_data_indics.f$lat),
                lng2 = max(STATIONS_data_indics.f$lon), 
                lat2 = max(STATIONS_data_indics.f$lat)) %>%
  addLayersControl( baseGroups = c("Part de mamies", "Evolution 1990-2013"), options = layersControlOptions(collapsed = F, autoZIndex = TRUE), position =  "topright") %>%
  addPolygons(data = REF_stations.ZT.wgs84,
              stroke = T,
              weight = 0.5,
              opacity = 50,
              fill = F, 
              color = "grey")
m$width <- 800
m$height <- 700
m


########
## sidebar

library(leaflet.extras2)

library(shiny)
runApp(paste0(system.file("examples", 
                          package = "leaflet.extras2"),
              "/sidebar_app.R"))
