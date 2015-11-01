###*
  ==UserScript==
  @name         Kibana4 Prettifier
  @version      0.1
  @author       gobie
  @match        http://kibana4.us-w2.aws.ccl/*
  @require      https://code.jquery.com/jquery-2.1.4.min.js
  ==/UserScript==
####

$ = jQuery.noConflict yes

prettify = ->
  shortenTime()
  shortenHostname()
  clickableAccountId()
  clickableUserId()
  colorRoutes()
  hideBoringFields()

shortenTime = do ->
  regex = /^(\w{3})\w+(\s\d+)\w+(\s\d+), (.+)$/
  ->
    $('doc-table .discover-table-timefield').filter(':not(.prettified)').each (i, el) ->
      $el = $(el)
      return unless regex.test $el.text()
      $el.html $el.html().replace regex, (_, month, day, year, time) ->
        month + day + year + '<br />' + time
      $el.addClass 'prettified'

shortenHostname = do ->
  regex = /^(\w+)\.[\w-]+\.\w+\.\w+$/
  appNameMap =
    app1: 'DEV'
    app2: 'MOBILE'
  ->
    $('doc-table .discover-table-datafield').filter(':not(.prettified)').each (i, el) ->
      $el = $(el)
      return unless regex.test $el.text()
      $el.html $el.html().replace regex, (_, name) ->
        appNameMap[name] ? name
      if $el.html() not in ['DEV', 'MOBILE']
        $el.closest('tr').css 'background-color': '#FCE1E3'
      $el.addClass 'prettified'

clickableAccountId = do ->
  regex = /^\d+$/
  ->
    $('doc-table .discover-table-datafield:nth-child(5n)').filter(':not(.prettified)').each (i, el) ->
      $el = $(el)
      return unless regex.test $el.text()
      $el.on 'click', ->
        window.open "https://admin.ccl/support-interface-2#/detail/account:#{$el.text()}"
      $el.addClass 'prettified'
      $el.attr 'role', 'button'

clickableUserId = do ->
  regex = /^\d+$/
  ->
    $('doc-table .discover-table-datafield:nth-child(6n)').filter(':not(.prettified)').each (i, el) ->
      $el = $(el)
      return unless regex.test $el.text()
      $el.on 'click', ->
        window.open "https://admin.ccl/support-interface-2#/detail/account:#{$el.prev().text()}-product:167111-user:#{$el.text()}"
      $el.addClass 'prettified'
      $el.attr 'role', 'button'

colorRoutes = do ->
  regex = /^(\w+\s)?[\w/-]+$/
  routesMap =
    '\/ads\/': 'rgba(0,0,0,0.4)'
    '\/metrics': '#FA6B6B'
    '\/posts\/': '#32C8FA'
    '\/listening\/': '#878A88'
    '\/exports\/|phantomjs': '#4349F7'
  ->
    $('doc-table .discover-table-datafield:nth-child(3n)').filter(':not(.prettified)').each (i, el) ->
      $el = $(el)
      return unless $el.text().match regex
      for routePattern, color of routesMap when (new RegExp routePattern).test $el.text()
        $el.css 'color', color
        break
      $el.addClass 'prettified'

hideBoringFields = do ->
  ->
    $('
      doc-table td[title="@version"],
      doc-table td[title="_id"],
      doc-table td[title="_index"],
      doc-table td[title="_lsi_name"],
      doc-table td[title="_lsi_port"],
      doc-table td[title="_lsi_type"],
      doc-table td[title="_lso_name"],
      doc-table td[title="_type"]
    ').closest('tr').remove()

setInterval prettify, 2000
