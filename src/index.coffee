'use strict'
AngularServiceGenerator = require './common/AngularServiceGenerator'
eventMappings = require './jitsi/eventMappings'

#create APP object
APP = require './jitsi/app'
APP.initAppObject()
#assign to window.APP
window.APP = APP

#wrap jitsi modules in angular
ajmModule = angular.module 'jm', [require './common']

for modName, mod of APP
  if typeof mod is 'object' #ignore the functions
    AngularServiceGenerator.wrapInAngular ajmModule, mod, modName
    if eventMappings.hasOwnProperty(modName)
      AngularServiceGenerator.makeEventConstants ajmModule, eventMappings[modName]

#Wrap the jitsi APP object in angular
ajmModule.factory 'jitsiApp', (EventAdapter) ->
  eventsWired = false

  APP.wireUpEvents = ->
    if !eventsWired
      console.log "---- Wiring UP Events"
      AngularServiceGenerator.wireUpEvents EventAdapter, ajmModule, APP, eventMappings
      eventsWired = true
    else
      console.log "---- Events Already Wired"

  APP.clearEvents = ->
    AngularServiceGenerator.clearEvents EventAdapter, eventMappings, APP
    eventsWired = false

  APP.wireUpEvents()

  APP

module.exports = ajmModule.name
