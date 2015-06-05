'use strict'
name = 'jm.xmpp'

xmppModule = angular.module name, []
xmppModule.constant 'XMPPEvents', require 'jitsi-meet/service/xmpp/XMPPEvents'

xmppModule.factory 'XMPPService', [
  '$rootScope'
  require './XMPPService'
]

xmppModule.factory 'MembersService', [
  '$log'
  '$rootScope'
  'XMPPService'
  require './MembersService'
]

module.exports = name: name