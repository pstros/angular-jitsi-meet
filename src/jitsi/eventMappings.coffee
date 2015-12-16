###
  This file defines the events that the jitsi modules emit
###

eventMappings =
  connectionquality:
    eventMaps:
      CQEvents: require 'jitsi-meet/service/connectionquality/CQEvents'

  desktopsharing:
    eventMaps:
      DesktopSharingEventTypes: require 'jitsi-meet/service/desktopsharing/DesktopSharingEventTypes'

  RTC:
    eventMaps:
      RTCEvents: require 'jitsi-meet/service/RTC/RTCEvents'
      StreamEventTypes: require 'jitsi-meet/service/RTC/StreamEventTypes'

  xmpp:
    eventMaps:
      XMPPEvents: require 'jitsi-meet/service/xmpp/XMPPEvents'

  statistics:
    eventMaps:
      StatisticsEvents: require 'jitsi-meet/service/statistics/Events'

module.exports = eventMappings
