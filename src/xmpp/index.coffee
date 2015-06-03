'use strict'
angular = require('angular')
angular.module('app.xmpp', []).factory 'XmppService', [
  '$log'
  '$rootScope'
  require('./XmppService')
]
