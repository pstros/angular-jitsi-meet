'use strict'

#global objects: APP, config

module.exports = (EventAdapter, RTCEvents, StreamEventTypes) ->
  RTC = require 'jitsi-meet/modules/RTC/RTC'
  EventAdapter.wireUpEvents { module: RTC, name: 'RTC' }, RTCEvents, StreamEventTypes
  RTC
