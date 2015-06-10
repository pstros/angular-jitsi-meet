'use strict'
name = 'jm.RTC'

commonModule = require '../common'

angularModule = angular.module name, [commonModule.name]
angularModule.constant 'RTCEvents', require 'jitsi-meet/service/RTC/RTCEvents'
angularModule.constant 'StreamEventTypes', require 'jitsi-meet/service/RTC/StreamEventTypes'

angularModule.factory 'RTCService', [
  'EventAdapter'
  'RTCEvents'
  'StreamEventTypes'
  require './RTCService'
]

module.exports = name: name