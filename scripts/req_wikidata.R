#######################
#### infos à récupérer
#######################

# 1 table lieu de tournage / film

# 1 table films
# caractéristiques du film


# 1 table lieux
# précision de la localisation du lieu de tournage



library(WikidataQueryServiceR)
library(tidyverse)
library(sf)

film_lieux <-
  query_wikidata('
  SELECT ?movie ?movieLabel ?narrative_location ?narrative_locationLabel ?coordinates WHERE {
   ?movie wdt:P840 ?narrative_location ;
          wdt:P31 wd:Q11424 .
   ?narrative_location wdt:P625 ?coordinates .
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],fr". }
}
')


# # Films avec un acteur
# film_details <-
#   query_wikidata('
#   SELECT ?item ?itemLabel (MIN(?date) AS ?firstReleased) ?_image
# WHERE {
#   ?item wdt:P161 wd:Q221074;
#   wdt:P577 ?date
#   SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
#   OPTIONAL { ?item wdt:P18 ?_image. }
# } GROUP BY ?item ?itemLabel ?_image
# ORDER BY (?date)
# ')


#################
# récupération de la liste des communes françaises
#################

wd_communes_fr <-
  query_wikidata('SELECT ?commune ?codeinsee {
  ?commune wdt:P31 wd:Q484170 . # commune
  ?commune wdt:P374 ?codeinsee .
}
') %>%
  rename(id_wd_commune = commune)

wd_communes_fr_xy <-
  query_wikidata('SELECT ?commune ?codeinsee ?coord {
  ?commune wdt:P31 wd:Q484170 . # commune
  ?commune wdt:P374 ?codeinsee .
  ?commune wdt:P625 ?coord .
}
') %>%
  rename(id_url_wd_commune = commune) %>%
  mutate(id_wd_commune = str_remove_all(id_url_wd_commune,"http://www.wikidata.org/entity/"))

# arrondissements PLM
wd_communesARR_fr_xy <-
  query_wikidata('SELECT ?commune ?codeinsee ?coord {
  ?commune wdt:P31 wd:Q702842 . # commune
  ?commune wdt:P374 ?codeinsee .
  ?commune wdt:P625 ?coord .
}
') %>%
  rename(id_url_wd_commune = commune) %>%
  mutate(id_wd_commune = str_remove_all(id_url_wd_commune,"http://www.wikidata.org/entity/"))

wd_communes_fr_xy <- wd_communes_fr_xy %>% rbind.data.frame(wd_communesARR_fr_xy)






#############
### export données
############


film_lieux.fmt <-
  film_lieux %>%
  mutate(coord = str_replace_all(coordinates, "Point","")) %>%
  mutate(coord = gsub("(", "", coord, fixed=TRUE)) %>%
  mutate(coord = gsub(")", "", coord, fixed=TRUE)) %>%
  separate(coord, c("lon", "lat"), " ", remove = F) %>%
  st_as_sf(., coords = c("lon", "lat"),
           crs = 4326, agr = "constant") %>%
  select(-coordinates, -coord) %>%
  identity()

library(geojsonsf)

write_sf(film_lieux.fmt, 
         dsn = "./carto_filmo/data/film_lieux.geojson", 
         delete_dsn = TRUE)

# préfixer fichier par 
# var src_film_lieux = {
# clore par
# }