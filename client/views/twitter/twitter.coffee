Template.shareit_twitter.onRendered ->
  return unless @data

  @autorun ->
    data = Template.currentData()
    $('meta[property^="twitter:"]').remove()

    #
    # Twitter cards
    #
    $('<meta>', { property: 'twitter:card', content: 'summary_large_image' }).appendTo 'head'

    site = data.twitter?.twitter || data.twitter
    $('<meta>', { property: 'twitter:site', content: '@' + site }).appendTo 'head'

    url = data.twitter?.url || data.url
    url = if _.isString(url) and url.length then url else ShareIt.location.origin() + ShareIt.location.pathname()
    $('<meta>', { property: 'twitter:url', content: url }).appendTo 'head'

    author = data.twitter?.author || data.twitter
    if _.isString(author) and author.length
      $('<meta>', { property: 'twitter:creator', content: '@' + author }).appendTo 'head'
    else
      author = ''
      
    title = data.twitter?.title || data.title
    if _.isString(title) and title.length
      $('<meta>', { property: 'twitter:title', content: title }).appendTo 'head'
    else
      title = ''

    description = data.twitter?.description || data.excerpt || data.description || data.summary
    if _.isString(description) and description.length
      $('<meta>', { property: 'twitter:description', content: description }).appendTo 'head'
    else
      description = ''

    if data.thumbnail?
      img = if _.isFunction data.thumbnail then data.thumbnail() else data.thumbnail  
      if _.isString(img) and img.length
        img = ShareIt.location.origin() + img unless /^http(s?):\/\/+/.test(img)          
        $('<meta>', { property: 'twitter:image', content: img }).appendTo 'head'
      else
        img = ''

# We need to call bitly from the onRendered method and not the click event. Cannot open a popup window from a callback as this is blocked by the browser
# http://stackoverflow.com/questions/18577928/meteor-callback-on-window-openurl-does-not-open-window
    utm = "utm_campaign=twitter&utm_medium=twitter&utm_source=twitter"
    
    longUrl = url + '?' + utm
    hashtags = data.twitter?.hashtags || data.hashtags || data.tags
    
    hashtags = hashtags.toString() if not _.isString(hashtags)
        
    hrefParams = "&hashtags=#{encodeURIComponent hashtags}" if _.isString(hashtags) and hashtags.length
            
    hrefParams += "&via=#{encodeURIComponent author}" if author


    Meteor.call 'getBitlyUrl', longUrl, (error, response) =>
      if error
        console.log 'bitly error:', error.reason
        # add link without bitly and no utm
        href = "https://twitter.com/intent/tweet?url=#{encodeURIComponent url}&text=#{encodeURIComponent title}"

      else
        #console.log 'Here ya go:', response.data.url
        href = "https://twitter.com/intent/tweet?url=#{encodeURIComponent response.data.url}&text=#{encodeURIComponent title}"
        
      href += hrefParams
      @templateInstance().$(".tw-share").attr "href", href

    

Template.shareit_twitter.helpers ShareIt.helpers

Template.shareit_twitter.helpers
  noButton: ->
        ShareIt.settings.sites.twitter.noButton
