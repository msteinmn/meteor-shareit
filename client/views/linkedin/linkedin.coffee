Template.shareit_linkedin.onRendered ->
  return unless @data

  @autorun ->
    template = Template.instance()
    data = Template.currentData()

    preferred_url = data.url || ShareIt.location.origin() + ShareIt.location.pathname()
    url = encodeURIComponent preferred_url
    description = encodeURIComponent data.pinterest?.description || data.excerpt || data.description || data.summary
    title = encodeURIComponent data.pinterest?.title || data.title
    
    #console.log 'pinterest:', preferred_url, url, data, description

    href = "https://www.linkedin.com/shareArticle?mini=true&url=#{url}"
    #&title=#{title}&description=#{description}"
#pin/create/button/?url=#{url}&media=#{img}&description=#{description}"

    template.$('.linkedin-share').attr 'href', href

Template.shareit_linkedin.events
  'click a': (event, template) ->
    event.preventDefault()
    window.open $(template.find('.linkedin-share')).attr('href'), 'linkedin_window', 'width=750, height=650'

Template.shareit_linkedin.helpers(ShareIt.helpers)