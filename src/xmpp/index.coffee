'use strict'
angular = require('angular')
angular.module('angular-jitsi-meet', []).factory 'XmppService', [
  '$log'
  '$rootScope'
  require('./XmppService')
]
