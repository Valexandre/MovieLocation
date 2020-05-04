# MovieLocation
Yet another way to find a movie to watch when you know what place you want to see

Grâce à [Johan Richer]("https://twitter.com/JohanRicher/status/1254368757557927937") et aux contributeurs de Wikidata, on a une très bonne base de travail pour les lieux où se déroulent les films.

La requête proposée par Johan.
```
#defaultView:Map
SELECT ?movie ?movieLabel ?narrative_location ?narrative_locationLabel ?coordinates WHERE {
   ?movie wdt:P840 ?narrative_location ;
          wdt:P31 wd:Q11424 .
   ?narrative_location wdt:P625 ?coordinates .
  SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
}
```

L'idée est de monter une carte interactive suffisamment chouette pour permettre d'enrichir à notre tour les données de Wikidata.
