var source = $("#popupTemplate").html();
var template = Handlebars.compile(source);

var lat = 52.50521;
var lon = 13.4231;
var zoom = 12;
var zoomed = false;
var padded_bounds = null;

I18n.defaultLocale = 'de';
I18n.locale = $('html').attr('lang');
I18n.fallbacks = true;

initGeoData();

var map = L.map('map', {
  center: [lat,lon],
  zoom: zoom,
  trackResize: true
});

// L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
L.tileLayer('http://{s}.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/{z}/{x}/{y}.png256', {
  maxZoom: 19,
  minZoom: 2,
  attribution: 'Data: <a href="http://www.openstreetmap.org/copyright">&copy; OpenStreetMap contributors</a>, Icons: CC-By-SA <a href="http://mapicons.nicolasmollet.com/">Nicolas Mollet</a>',
  detectRetina: true

}).addTo(map);
map.attributionControl.setPrefix('');
L.control.locate().addTo(map);
map.addControl(new L.Control.Permalink({text: 'Permalink', useAnchor: false, position: 'topright'}));

var geojson_layer = L.geoJson(null).addTo(map);

var standort = L.icon({
  iconSize:     [1, 1],
  iconAnchor:   [7, 2],
  popupAnchor:  [10, 20],
  iconUrl: '/images/location.png'
});


map.on('movestart', function(e) {
  // Recall the current bounds with padding for later use
  if ( !padded_bounds || padded_bounds === null ) {
    padded_bounds = map.getBounds().pad(0.42);
  }
}).on('moveend', function(e) {
  // Ignore moving of the map if panned just 40% of the visible mapc
  if (zoomed === true || padded_bounds !== null && !padded_bounds.contains(map.getBounds())) {
    $.cookie('last_lat', map.getCenter().lat, { expires: 7, path: '/' });
    $.cookie('last_lon', map.getCenter().lng, { expires: 7, path: '/' });
    update_permalink('.createlink');
    requestNodes(e.target.getBounds());
    padded_bounds = null;
    zoomed = false;
  }
}).on('zoomstart', function(e){
  zoomed = true;
}).on('zoomend', function(e){
  $.cookie('last_zoom', map.getZoom(), { expires: 7, path: '/' });
  update_permalink('.createlink');
}).on('popupopen', function(e) {
  window.node_id = e.popup._source.feature.properties.id.toString();
  var wheelchair_class = e.popup._source.feature.properties.wheelchair;
  $('#featurePopup_content_' + window.node_id + ' .' + wheelchair_class + ' input').prop('checked',true);
  $('.update_form').bind('ajax:success', function(xhr, data, status){
    $('<div class="notification active notice"><span>'+ data.message + '</span></div>').insertAfter('#toolbar .content').slideDown(500).delay(8000).slideUp(400, function() { $(this).remove()});
    if (window._gaq) {
      _gaq.push(['_trackEvent', 'Data', 'Tag', data.wheelchair]);
    }
  }).bind('ajax:error', function(xhr, data, status){
    $('<div class="notification active error"><span>'+ data.message + '</span></div>').insertAfter('#toolbar .content').slideDown(500).delay(8000).slideUp(400, function() { $(this).remove()});
    if (window._gaq) {
      _gaq.push(['_trackEvent', 'Data', 'Tag', 'failed']);
    }
  });
}).on('popupclose', function(e){
   window.node_id = null;
});

function update_permalink(selector) {
  $(selector).attr('href', '/nodes/new?' + jQuery.param({lat: map.getCenter().lat,lon: map.getCenter().lng,zoom: 17}));
}

function requestNodes(bounds) {
  map.spin(true);
  $.ajax(
    {
      type: 'GET',
      url: '/nodes.geojson',
      dataType: 'json',
      data: {
        bbox:bounds.toBBoxString(),
        limit: 400
      },
      closeOnClick: false,
      load: true,
      contentType: 'application/json; charset=utf-8',
      success: function (result) {
        parseResponse(result)
      },
      error: function (req, status, error) {
        $('<div class="notification active error"><span>'+ error + '</span></div>').insertAfter('#toolbar .content').slideDown(500).delay(8000).slideUp(400, function() { $(this).remove()});
      },
      complete: function(res) {
        map.spin(false);
      }
  });
}

function onEachFeature(feature, layer) {
  if (feature.properties.name === null) {
    feature.properties.name = I18n.t("poi.name."+feature.properties.category+"."+ feature.properties.type)
  }
  feature.properties.status_text = I18n.t('wheelchairstatus.' + feature.properties.wheelchair);
  feature.properties.status_description = I18n.t('wheelmap.what_is.' + feature.properties.accesibility);
  var popup_html = template(feature.properties);
  var popup = layer.bindPopup(popup_html, { closeButton: false });

  // Save the popup to be opened later on
  if (window.node_id && window.node_id === feature.properties.id.toString()) {
    window.popup = popup;
  }
}

function initGeoData() {
  // set global variables
  q = $.parseQuery()
  lat  = q.lat  || $.cookie('last_lat') || $.cookie('geoip_lat') || 52.5167;
  lon  = q.lon  || $.cookie('last_lon') || $.cookie('geoip_lon') || 13.4000;
  zoom = q.zoom || $.cookie('last_zoom') || 14;
  window.node_id = q.node_id
}

function parseResponse(data) {
  var new_geojson_layer = new L.GeoJSON(data, {
    pointToLayer: function (feature, latlng) {
      var classesToAdd = [feature.properties.wheelchair, feature.properties.category]
      $('.status-filter button:not(.active)').each(function() {
        var filter_class = $(this).attr('data-value');
        if ( feature.properties.wheelchair === filter_class ) {
          classesToAdd.push('wheelchair_hidden');
        }
      });

      $('.category-filter option:not(:selected)').each(function() {
        var filter_class = $(this).val();
        if ( feature.properties.category === filter_class ) {
          classesToAdd.push('category_hidden');
        }
      });
      return L.marker(latlng, {
        icon: L.divIcon({
          iconSize:     [29, 32],
          iconAnchor:   [15, 30],
          popupAnchor:  [0, -8],
          className: classesToAdd.join(' '),
          html: '<div id="'+ feature.properties.icon +'" class="icon"></div>'
        }),
        title: feature.properties.name,
        riseOnHover: true
      });
    },
    onEachFeature: onEachFeature
  });
  map.addLayer(new_geojson_layer);
  if (geojson_layer != undefined)
  {
    map.removeLayer(geojson_layer);
  }
  geojson_layer = new_geojson_layer;

  // Is there a popup? Then open it now!
  if (window.popup) {
    window.popup.openPopup();
  }
}

$('.status-filter button').button()
  .on('change', function(e) {
    var $this = $(this), filter_class;

    filter_class = $this.attr('data-value');

    if (!$this.hasClass('active')) {
      $('.leaflet-marker-icon.' + filter_class).addClass('wheelchair_hidden');
      $.cookie('filter_' + filter_class, '1', { expires: 7, path: '/' });
    } else {
      $('.leaflet-marker-icon.' + filter_class).removeClass('wheelchair_hidden');
      $.removeCookie('filter_' + filter_class, { path: '/' });
    }
  });

$('.category-filter').on('change', function(e){
  $(e.target).find('option').each(function(i) {
    var filter_class = $(this).val();
    if ( $(this).is(':selected') ) {
      $('.leaflet-marker-icon.' + filter_class).removeClass('category_hidden');
      $.removeCookie('filter_'+filter_class, { path: '/' });
    } else {
      $.cookie('filter_'+filter_class, '1', { expires: 7, path: '/' });
      $('.leaflet-marker-icon.' + filter_class).addClass('category_hidden');
    }
  })
});

var $statusFilterButtons = $('.status-filter button'),
  $categoryFilter = $('.category-filter'),
  filterCookie = false;


$(['yes', 'no', 'limited', 'unknown']).each(function (index, item) {
  if ($.cookie('filter_' + item)) {
    filterCookie = true;
    $statusFilterButtons.filter('.' + item).removeClass('active');
  }
});

$categoryFilter.find('option').each(function () {
  var filter_class = $(this).val();
  if (!$.cookie('filter_' + filter_class)) {
    $(this).attr('selected', 'selected');
  }
});

$statusFilterButtons.popover({
  trigger: 'hover',
  placement: getPopoverPlacement
}).click(function () {
    $('.popover').fadeOut(300);
  });

$statusFilterButtons.click(function(event) {
  event.stopPropagation();

  if (filterCookie) {
    $(this).toggleClass('active').trigger('change');
    return;
  }

  filterCookie = true;
  $statusFilterButtons.not(this).removeClass('active').trigger('change');
});

$('.btn-searchbar').click(function () {
  $('.navbar-form').toggleClass('active');
});

function getPopoverPlacement() {
  if (window.innerWidth < 767) {
    return 'top';
  } else {
    return 'bottom';
  }
}

function ResizeElements() {
  var widthTablet = $(window).width();
  if (widthTablet < 767) {
    $('.category-filter').addClass('dropup');
  }
  else {
    $('.category-filter').removeClass('dropup');
  }
}

$(window).load(ResizeElements);
$(window).resize(ResizeElements);
update_permalink('.createlink');
requestNodes(map.getBounds());
