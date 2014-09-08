
Wheelmap.LocateMixin = Ember.Mixin.create
  _createLayer: ()->
    @_super()
    L.control.locate().addTo(@_layer)

Wheelmap.SpinMixin = Ember.Mixin.create
  spinner: null,
  spinning: 0

  spin: (state)->
    if state
      unless @spinner?
        @spinner = new Spinner().spin(@get('element'));

      @spinning++
    else
      @spinning--

      if @spinning <= 0 and @spinner?
        @spinner.stop()
        @spinner = null

Wheelmap.TileLayer = EmberLeaflet.TileLayer.extend
  tileUrl: 'http://{s}.tiles.mapbox.com/v3/sozialhelden.map-iqt6py1k/{z}/{x}/{y}.png256'
  options:
    maxZoom: 19
    minZoom: 2
    attribution: 'Data: <a href="http://www.openstreetmap.org/copyright">&copy; OpenStreetMap contributors</a>, Icons: CC-By-SA <a href="http://mapicons.nicolasmollet.com/">Nicolas Mollet</a>'
    detectRetina: true

Wheelmap.MarkerLayer = EmberLeaflet.Layer.extend
  mapBinding: 'parentLayer'
  mapControllerBinding: 'map.controller'
  toolbarControllerBinding: 'mapController.controllers.toolbar'
  poppingNodeBinding: 'mapController.poppingNode'
  lastLoadedBounds: null
  lastActiveStatusFilters: null
  lastActiveCategories: null
  $nodeView: null
  $nodeViewPrev: null
  popupNodeId: null

  geoJSONLayer: (()->
    new L.GeoJSON null,
      pointToLayer: $.proxy(@.pointToLayer, @)
  ).property()

  filterLayers: ()->
    @_filterLayers()

  didCreateLayer: ()->
    @_boundsDidChange()

    map = @get('map.layer')

    if map?
      # Needed for starting own popup opening process when marker were clicked
      map.on('click', @_onClick, @)

  requestData: (bounds)->
    that = @

    if that.lastLoadedBounds? and that.lastLoadedBounds.contains(bounds)
      # Does it move far enough?
      return

    map = that.get('map')
    map.set('isLoading', true)

    request = $.ajax '/nodes.geojson',
      data:
        bbox: bounds.toBBoxString()
        node_id: @get('poppingNode.id')

    request.then (data)->
      Ember.run.once(that, 'replaceData', data)

      that.lastLoadedBounds = bounds.pad(Wheelmap.MarkerLayer.BOUNDS_CONTAINS_BUFFER)
      map.set('isLoading', false)

  replaceData: (data)->
    geoJSONLayer = @get('geoJSONLayer')
    geoJSONLayer.clearLayers()
    geoJSONLayer.addData(data)

    @openPopup()
    @filterLayers()

  pointToLayer: (featureData, latlng)->
    layer = Wheelmap.MarkerLayer.createLayer(latlng, featureData.properties)
    layer.on('click', @_onClick, @)

  sendPopupAction: (nodeId)->
    mapController = @get('mapController')

    if nodeId?
      # @TODO add this only for mobile devices with lower bandwidth
      # @get('map').set('isLoading', true)
      mapController.send('openPopup', nodeId)
    else
      mapController.send('closePopup')

  openPopup: (()->
    poppingNode = @get('poppingNode')

    if poppingNode?
      nodeId = poppingNode.get('id')

      if @popupNodeId is nodeId
        # Node popup allready open
        return

      @popupNodeId = nodeId

      Ember.run.scheduleOnce('afterRender', @, @_openPopup, nodeId)
      # @TODO add this only for mobile devices with lower bandwidth
      # Ember.run.scheduleOnce('afterRender', @get('map'), 'set', 'isLoading', false)
      Ember.run.scheduleOnce('afterRender', poppingNode, 'send', 'opened')
  ).observes('poppingNode.id')

  closePopup: (()->
    poppingNode = @get('poppingNode')

    if poppingNode?
      @_closePopup(poppingNode.get('id'))
      @popupNodeId = null
      poppingNode.send('closed')
      Ember.run.once(@, @filterLayers)
  ).observesBefore('poppingNode.id')

  getLayer: (nodeId)->
    @get('geoJSONLayer').getLayers().findBy('feature.properties.id', parseInt(nodeId, 10))

  getViewElement: ()->
    unless @$nodeView?
      @$nodeView = $('.node-popup-view')
      @$nodeViewPrev = @$nodeView.prev()

    @$nodeView[0]

  resetViewElement: ()->
    if @$nodeView? and @$nodeViewPrev?
      @$nodeViewPrev.after(@$nodeView)

      @$nodeView = null
      @$nodeViewPrev = null

  _openPopup: (nodeId)->
    marker = @getLayer(nodeId)

    unless marker?
      return

    map = @get('map.layer')

    marker.setZIndexOffset(marker.options.riseOffset)
    viewElement = @getViewElement()

    map.openPopup viewElement, marker.getLatLng(),
      className: 'node-popup'
      offset: [0, -24]
      closeOnClick: false
      closeButton: false

  _closePopup: (nodeId)->
    @getLayer(nodeId)?.setZIndexOffset(0)
    @resetViewElement()
    @get('map.layer').closePopup()

  _onClick: (event)->
    nodeId = null

    if event.target instanceof L.Marker
      nodeId = event.target.feature.properties.id

    @sendPopupAction(nodeId)

  _newLayer: ()->
    @get('geoJSONLayer')

  _filterLayers: ()->
    layers = @get('geoJSONLayer').getLayers()

    if layers.length == 0
      return

    activeStatusFilters = @get('toolbarController.activeStatusFilters').getEach('key')
    activeCategories = @get('toolbarController.activeCategories').getEach('identifier')
    poppingNode = @get('poppingNode')

    for layer in layers
      properties = layer.feature.properties
      visible = activeStatusFilters.contains(properties.wheelchair) and
        activeCategories.contains(properties.category)

      if poppingNode? and properties.id is parseInt(poppingNode.get('id'), 10)
        visible = true

      $(layer._icon).toggle(visible)

    return

  _statusFilterDidChange: (()->
    if Ember.compare(@lastActiveStatusFilters, @get('toolbarController.activeStatusFilters')) is 0
      return

    @lastActiveStatusFilters = @get('toolbarController.activeStatusFilters')
    @filterLayers()
  ).observes('toolbarController.activeStatusFilters.@each')

  _categoriesDidChange: (()->
    if Ember.compare(@lastActiveCategories, @get('toolbarController.activeCategories')) is 0
      return

    @lastActiveCategories = @get('toolbarController.activeCategories')
    @filterLayers()
  ).observes('toolbarController.activeCategories.@each')

  _boundsDidChange: (()->
    if @get('map.isMoving') or @get('map.isZooming')
      return

    layer = @get('map.layer')

    unless layer?
      return

    Ember.run.debounce(@, 'requestData', layer.getBounds(), 200)
  ).observes('map.isMoving', 'map.isZooming', 'map.layer')

  _zoomDidChange: (()->
    # When zooming reset last loaded bounds to load nodes in any case
    @lastLoadedBounds = null
  ).observes('map.zoom')

  _poppingNodeWheelchairDidChange: (()->
    poppingNode = @get('poppingNode')

    unless poppingNode?
      return

    marker = @getLayer(poppingNode.get('id'))

    if marker?
      options = poppingNode.getProperties('wheelchair', 'icon', 'sponsor')
      icon = Wheelmap.MarkerLayer.createIcon(options)

      $.extend(marker.feature.properties, options)
      marker.setIcon(icon)
  ).observes('poppingNode.wheelchair')

Wheelmap.MarkerLayer.reopenClass
  BOUNDS_CONTAINS_BUFFER: 0.41

  createLayer: (latlng, options)->
    new L.Marker latlng,
      title: options.name
      riseOnHover: true
      icon: Wheelmap.MarkerLayer.createIcon(options)

  createIcon: (options)->
    markerClassName = 'marker-wheelchair-' + options.wheelchair
    html = ''

    unless options.sponsor?
      iconClassName = 'marker-icon marker-icon-' + options.icon
      html = "<div class=\"#{iconClassName}\"></div>"
    else
      html = "<img class=\"marker-sponsor-image\" src=\"#{options.sponsor}\" alt=\"#{options.name}\" />"

    new L.DivIcon
      iconSize: null
      iconAnchor: null
      popupAnchor: null
      className: markerClassName
      html: html

Wheelmap.MapView = EmberLeaflet.MapView.extend Wheelmap.LocateMixin, Wheelmap.SpinMixin,
  childLayers: [ Wheelmap.TileLayer, Wheelmap.MarkerLayer ]
  options:
    trackResize: true

  openedPopup: null

  center: Ember.computed.oneWay('controller.center')
  zoom: Ember.computed.oneWay('controller.zoom')

  didInsertElement: ()->
    Ember.run.sync() # Needed for bindings to controller

    @_super()
    @get('layer')?.attributionControl.setPrefix('')

  bboxDidChange: (->
    layer = @get('layer')

    unless layer?
      return

    bbox = @get('controller.bbox')

    if bbox?
      layer.fitBounds(bbox)
  ).observes('controller.bbox', 'layer')

  isMovingDidChange: (->
    if @get('isMoving')
      return

    controller = @get('controller')
    controller.set('center', @get('center'))
  ).observes('isMoving')

  isZoomingDidChange: (->
    if @get('isZooming')
      return

    controller = @get('controller')
    controller.set('zoom', @get('zoom'))
  ).observes('isZooming')

  loading: (()->
    @spin(@get('isLoading'))
  ).observes('isLoading')