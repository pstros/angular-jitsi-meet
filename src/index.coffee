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
ajmModule.provider 'jitsiApp', ->
  vm = this
  eventsWired = false
  vm.config =
    wireEvents: true

  vm.wireEvents = (shouldWireEvents) ->
    vm.config.wireEvents = shouldWireEvents

  vm.$get = (EventAdapter) ->
    APP.wireUpEvents = ->
      if !eventsWired
        for modName, eventMapping of eventMappings
          AngularServiceGenerator.wireUpEvents EventAdapter, ajmModule, APP[modName], eventMapping
        eventsWired = true

    APP.clearEvents = ->
      for modName, eventMapping of eventMappings
        AngularServiceGenerator.clearEvents EventAdapter, eventMapping, APP[modName]
      eventsWired = false

    if vm.config.wireEvents
      APP.wireUpEvents()
    return APP

  return vm

module.exports = ajmModule.name
