'use strict'

angularModule = angular.module 'common', []

angularModule.factory 'EventAdapter', require './EventAdapter'
angularModule.factory 'AngularServiceGenerator', ->
  require './AngularServiceGenerator'

module.exports = angularModule.name