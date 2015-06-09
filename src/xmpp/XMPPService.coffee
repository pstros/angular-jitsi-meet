'use strict'

#global objects: APP, config

module.exports = ($rootScope, EventAdapter) ->
  XMPP = require 'jitsi-meet/modules/xmpp/xmpp'

  XMPPEvents = require 'jitsi-meet/service/xmpp/XMPPEvents'
  EventAdapter.wireUpEvents XMPP, XMPPEvents
  XMPP
