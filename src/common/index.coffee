'use strict'

angularModule = angular.module 'common', []

angularModule.factory 'EventAdapter', require './EventAdapter'
angularModule.factory 'AngularServiceGenerator', ->
  require './AngularServiceGenerator'
 
console.log "--- Module Name = ", angularModule.name

module.exports = angularModule.name
