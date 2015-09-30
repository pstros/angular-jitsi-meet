initialized = false

APP =
  initAppObject: ->
    @UI = require './UI'
    @connectionquality = require 'jitsi-meet/modules/connectionquality/connectionquality'
    @statistics = require 'jitsi-meet/modules/statistics/statistics'
    @RTC = require 'jitsi-meet/modules/RTC/RTC'
    @desktopsharing = require 'jitsi-meet/modules/desktopsharing/desktopsharing'
    @xmpp = require 'jitsi-meet/modules/xmpp/xmpp'
    @settings = require 'jitsi-meet/modules/settings/Settings'
    initialized = true
    
  startJitsiServices: ->
    @initAppObject() if not initialized

    @desktopsharing.init()
    @RTC.start()
    @xmpp.start()
    @statistics.start()
    @connectionquality.init()

module.exports = APP


