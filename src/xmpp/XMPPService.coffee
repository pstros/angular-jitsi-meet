'use strict'

#global objects: APP, config

module.exports = (EventAdapter, XMPPEvents) ->
  XMPP = require 'jitsi-meet/modules/xmpp/xmpp'
  EventAdapter.wireUpEvents { module: XMPP, name: 'xmpp' }, XMPPEvents
  XMPP
