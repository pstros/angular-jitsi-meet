###
  This file defines the jitsi modules to generate angular services for and to wire up events on
###

jitsiModules =
  Settings:
    module: require 'jitsi-meet/modules/settings/Settings'

# this module has been removed in jitsi/jitsi-meet's master so we shouldn't need it
#  simulcast:
#    module: require 'jitsi-meet/modules/simulcast/simulcast'

  desktopsharing:
    module: require 'jitsi-meet/modules/desktopsharing/desktopsharing'
    options:
      eventMaps:
        DesktopSharingEventTypes: require 'jitsi-meet/service/desktopsharing/DesktopSharingEventTypes'
      flipAddListenerArgs: true

  xmpp:
    module: require 'jitsi-meet/modules/xmpp/xmpp'
    options:
      eventMaps:
        XMPPEvents: require 'jitsi-meet/service/xmpp/XMPPEvents'
  
  RTC:
    module: require 'jitsi-meet/modules/RTC/RTC'
    options:
      eventMaps:
        RTCEvents: require 'jitsi-meet/service/RTC/RTCEvents'
        StreamEventTypes: require 'jitsi-meet/service/RTC/StreamEventTypes'

module.exports = jitsiModules