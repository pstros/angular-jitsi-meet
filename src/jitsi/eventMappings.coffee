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
    flipAddListenerArgs: true
      
  RTC:
    eventMaps:
      RTCEvents: require 'jitsi-meet/service/RTC/RTCEvents'
      StreamEventTypes: require 'jitsi-meet/service/RTC/StreamEventTypes'

  #TODO: refactor statistics to pull its list of events from service/statistics/StatisticsEvents
#  statistics:

  xmpp:
    eventMaps:
      XMPPEvents: require 'jitsi-meet/service/xmpp/XMPPEvents'

module.exports = eventMappings