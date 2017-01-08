Template.shareit_facebook.onRendered ->
  return unless @data

  attach_share_handler = _.once (handler) ->
    Template.instance().$('.fb-share').click handler if _.isFunction handler

  @autorun ->    
    data = Template.currentData()
    $('meta[property^="og:"]').remove()

    #
    # OpenGraph tags
    #
    $('<meta>', { property: 'og:type', content: 'article' }).appendTo 'head'
    $('<meta>', { property: 'og:site_name', content: ShareIt.location.hostname() }).appendTo 'head'

    # og:url is a redirect for the Facebook crawler
    # to go look at the redirect page instead
    # We don't want that here
    url = data.facebook?.url || data.url
    url = if _.isString(url) and url.length then url else ShareIt.location.href()
    #url = url + '/'
    $('<meta>', { property: 'og:url', content: url }).appendTo 'head'
    
    # set the canonical link (same as og:url)
    $('link[rel^="canonical"]').remove()
    $('<link>', { rel: 'canonical', href: url }).appendTo 'head'
    
    #console.log '--------------facebook url:', url
    
    if ShareIt.settings.sites.facebook.locale?
      $('<meta>', { property: 'og:locale', content: ShareIt.settings.sites.facebook.locale }).appendTo 'head'

    title = data.facebook?.title || data.title
    if _.isString(title) and title.length
      $('<meta>', { property: 'og:title', content: title }).appendTo 'head'
    else
      title = ''
        
    updatedAt = JSON.stringify data.facebook?.updatedAt || data.updatedAt
    updatedAt = updatedAt.replace(/['"]+/g, '')
    if _.isString(updatedAt) and updatedAt.length
      $('<meta>', { property: 'og:updated_time', content: updatedAt }).appendTo 'head'
    else
      updatedAt = ''

    description = data.facebook?.description || data.excerpt || data.description || data.summary
    if _.isString(description) and description.length
      $('<meta>', { property: 'og:description', content: description }).appendTo 'head'
      
      # replace standard description
      $('meta[name^="description"]').remove()
      $('<meta>', { name: 'description', content: description }).appendTo 'head'
    else
      description = ''

    author = data.facebook?.author || data.author
    if _.isString(author) and author.length
      $('<meta>', { property: 'article:author', content: author }).appendTo 'head'
    else
      author = ''

    publisher = data.facebook?.publisher || data.publisher
    if _.isString(publisher) and publisher.length
      $('<meta>', { property: 'article:publisher', content: publisher }).appendTo 'head'
    else
      publisher = ''

    if data.thumbnail?
      img = if _.isFunction data.thumbnail then data.thumbnail() else data.thumbnail

      if _.isString(img) and img.length
        img = ShareIt.location.origin() + img unless /^http(s?):\/\/+/.test(img)
        $('<meta>', { property: 'og:image', content: img }).appendTo 'head'
      else
        img = ''

    $('meta[property^="fb:app_id"]').remove()
    if ShareIt.settings.sites.facebook.appId?
      $('<meta>', { property: 'fb:app_id', content: ShareIt.settings.sites.facebook.appId }).appendTo 'head'

      attach_share_handler (evt) ->
        evt.preventDefault()
        FB.ui {method: 'share', display: 'popup', href: url}, (res) -> res
    else
# Facebook sharer.php is depracated. We no longer need to URL-encode all the parameters
#      href = "https://www.facebook.com/sharer/sharer.php?s=100&p[url]=#{encodeURIComponent url}&p[title]=#{encodeURIComponent title}&p[summary]=#{encodeURIComponent description}"
#      href += "&p[images][0]=#{encodeURIComponent img}" if img
      href = "https://www.facebook.com/sharer/sharer.php?u=#{encodeURIComponent url}"

      Template.instance().$(".fb-share").attr "href", href

Template.shareit_facebook.helpers ShareIt.helpers

Template.shareit_facebook.helpers
  noButton: ->
        ShareIt.settings.sites.facebook.noButton
