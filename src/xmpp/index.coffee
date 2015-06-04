'use strict'
name = 'jm.xmpp'
angular.module(name, []).factory 'XmppService', [
  '$log'
  '$rootScope'
  require('./XmppService')
]

module.exports = name: name