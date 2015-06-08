'use strict'
name = 'jm.xmpp'

#commonModule = require '../common'

angularModule = angular.module name, []#[commonModule.name]
angularModule.constant 'XMPPEvents', require 'jitsi-meet/service/xmpp/XMPPEvents'

angularModule.factory 'XMPPService', [
  '$rootScope'
  'EventAdapter'
  require './XMPPService'
]

angularModule.factory 'MemberService', [
  '$log'
  '$rootScope'
  'XMPPService'
  require './MemberService'
]

module.exports = name: name