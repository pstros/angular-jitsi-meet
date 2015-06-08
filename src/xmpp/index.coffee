'use strict'
name = 'jm.xmpp'

xmppModule = angular.module name, []
xmppModule.constant 'XMPPEvents', require 'jitsi-meet/service/xmpp/XMPPEvents'

xmppModule.factory 'XMPPService', [
  '$rootScope'
  require './XMPPService'
]

xmppModule.factory 'MemberService', [
  '$log'
  '$rootScope'
  'XMPPService'
  require './MemberService'
]

module.exports = name: name