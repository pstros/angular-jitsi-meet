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

  startJitsiServices: (jid, password, startDesktopSharing) ->
    startDesktopSharing = startDesktopSharing || false

    @initAppObject() if not initialized

    if startDesktopSharing
      @desktopsharing.init()

    @RTC.start()
    @xmpp.start(jid, password)
    @statistics.start()
    @connectionquality.init()

  stopJitsiServices: ->
    console.log 'global jitsi shutdown'
    @RTC.stop()
    @statistics.stop()
    @desktopsharing.destroy()
    @connectionquality.stopSendingStats()

module.exports = APP
