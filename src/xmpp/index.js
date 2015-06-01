'use strict'

var angular = require('angular');

angular.module('angular-jitsi-meet', []).factory('XmppService', ['$log', '$rootScope', require('./XmppService')]);