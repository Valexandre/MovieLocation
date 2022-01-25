// <script src="data/rep5G_extrait.geojson" type="text/javascript"></script>



// basemap
	var mymap = L.map('mapid', {
    zoomSnap: 0.25,
    zoomControl: false,
    renderer: L.canvas(),
  }).setView([46.5, 2.55], 5.5555);

	// var mymap = L.map('mapid').setView([39.74739, -105], 13);

	L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw', {
		maxZoom: 16,
		attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, ' +
			'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
		id: 'mapbox/streets-v11',
		tileSize: 512,
		zoomOffset: -1
	}).addTo(mymap);


	function onEachFeature(feature, layer) {
	  var popupContent = "<p> Film : " +
	      feature.properties.movieLabel + "</p>";

	  // if (feature.properties && feature.properties.operateur) {
	  //   popupContent += feature.properties.operateur;
	  // }

	  layer.bindPopup(popupContent);
	}



// circleMarker

	var geojsonMarkerOptions = {
	    radius: 4,
	    fillColor: "#0163FF",
	    color: "#0163FF",
	    weight: 2,
	    opacity: 1,
	    fillOpacity: 0.4,
	};


	L.geoJSON([src_film_lieux], {

	  style: function (feature) {
	    return feature.properties && feature.properties.style;
	  },

	  onEachFeature: onEachFeature,

	  pointToLayer: function (feature, latlng) {
	    return L.circleMarker(latlng, geojsonMarkerOptions);
	  }
	}).addTo(mymap);
