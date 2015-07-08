###
  This file defines the jitsi modules to generate angular services for and to wire up events on
###

jitsiModules =
  API:
    module: require 'jitsi-meet/modules/API/API'
  
  connectionquality:
    module: require 'jitsi-meet/modules/connectionquality/connectionquality'
    options:
      eventMaps:
        CQEvents: require 'jitsi-meet/service/connectionquality/CQEvents'
    
  desktopsharing:
    module: require 'jitsi-meet/modules/desktopsharing/desktopsharing'
    options:
      eventMaps:
        DesktopSharingEventTypes: require 'jitsi-meet/service/desktopsharing/DesktopSharingEventTypes'
      flipAddListenerArgs: true

  DTMF:
    module: require 'jitsi-meet/modules/DTMF/DTMF'
  
  keyboardshortcut:
    module: require 'jitsi-meet/modules/keyboardshortcut/keyboardshortcut'
    
  members:
    module: require 'jitsi-meet/modules/members/MemberList'
    options:
      eventMaps:
        Events: require 'jitsi-meet/service/members/Events'
      
  RTC:
    module: require 'jitsi-meet/modules/RTC/RTC'
    options:
      eventMaps:
        RTCEvents: require 'jitsi-meet/service/RTC/RTCEvents'
        StreamEventTypes: require 'jitsi-meet/service/RTC/StreamEventTypes'

  Settings:
    module: require 'jitsi-meet/modules/settings/Settings'
  
  statistics:
    module: require 'jitsi-meet/modules/statistics/statistics'
    #TODO: refactor statistics to pull its list of events from service/statistics/StatisticsEvents
    
  translation:
    module: require 'jitsi-meet/modules/translation/translation'
    
# this module has side effects right now
#  URLProcessor:
#    module: require 'jitsi-meet/modules/URLProcessor/URLProcessor'

  xmpp:
    module: require 'jitsi-meet/modules/xmpp/xmpp'
    options:
      eventMaps:
        XMPPEvents: require 'jitsi-meet/service/xmpp/XMPPEvents'

module.exports = jitsiModules