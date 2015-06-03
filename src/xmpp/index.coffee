'use strict'
angular.module('jm.xmpp', []).factory 'XmppService', [
  '$log'
  '$rootScope'
  require('./XmppService')
]
