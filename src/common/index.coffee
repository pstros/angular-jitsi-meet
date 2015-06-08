'use strict'
name = 'jm.common'

angularModule = angular.module name, []

angularModule.factory 'EventAdapter', [
  '$log'
  '$rootScope'
  require './EventAdapter'
]

module.exports = name: name