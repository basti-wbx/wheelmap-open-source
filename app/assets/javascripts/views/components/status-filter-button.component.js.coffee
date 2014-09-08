Wheelmap.StatusFilterButtonComponent = Wheelmap.WheelchairPopoverComponent.extend
  tagName: 'button'
  classNameBindings: [':btn', 'isActive:active', ':btn-info', 'wheelchair']
  wheelchair: null
  activeFilters: null

  init: ()->
    @_super()

  popoverOptions:
    trigger: 'hover'
    placement: () ->
      if window.innerWidth <= 767 then 'top' else 'bottom'
    delay: { show: 400 }
    container: '#toolbar .status-filter' # Need for not having little spaces between status buttons

  isActive: (()->
    @get('activeFilters').findBy('key', @get('wheelchair'))?
  ).property('wheelchair', 'activeFilters.@each')

  click: (event)->
    event.preventDefault();

    @sendAction('didClick', @get('wheelchair'))