Template.shareit_pinterest.onRendered ->
  return unless @data

  @autorun ->
    template = Template.instance()
    data = Template.currentData()

    preferred_url = data.url || ShareIt.location.origin() + ShareIt.location.pathname()
    url = encodeURIComponent preferred_url
    description = encodeURIComponent data.pinterest?.description || data.excerpt || data.description || data.summary
    
    if data.thumbnail?
      img = if _.isFunction data.thumbnail then data.thumbnail() else data.thumbnail

      if _.isString(img) and img.length
        img = ShareIt.location.origin() + img unless /^http(s?):\/\/+/.test(img)
      else
        img = ''
    
    #console.log 'pinterest:', preferred_url, url, img, description

    href = "http://www.pinterest.com/pin/create/button/?url=#{url}&media=#{img}&description=#{description}"

    template.$('.pinterest-share').attr 'href', href

Template.shareit_pinterest.events
  'click a': (event, template) ->
    event.preventDefault()
    window.open $(template.find('.pinterest-share')).attr('href'), 'pinterest_window', 'width=750, height=650'

Template.shareit_pinterest.helpers(ShareIt.helpers)
