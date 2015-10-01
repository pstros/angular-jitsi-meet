'use strict'


AngularServiceGenerator =
  ###
    Creates an angular service which wraps module and wires up events from options.eventMaps. It also creates
    angular constants for each list of events.
    * Assumes that options.eventMaps is an object with keys being the angular constant name and value being an object of
    key value pairs of events.  See eventMappings.coffee for an example

    @input moduleObject
    @input moduleName
    @input options - an object with eventMaps, and flipAddListenerArgs properties. All are optional
    @returns angularModuleName
  ###
  wrapInAngular: (angularModule, moduleObject, moduleName)->
    if !moduleObject or !moduleName
      throw Error 'module and moduleName are required parameters'

    console.debug "Creating angular service #{moduleName} in #{angularModule.name} for #{moduleName} module"

    angularModule.factory moduleName, [ -> moduleObject ] #create a service with no events registered

    angularModule

  makeEventConstants: (angularModule, eventMapping) ->
    for eventMapName, eventMap of eventMapping.eventMaps
      console.debug "Creating angular constant #{eventMapName} in #{angularModule.name}"
      angularModule.constant eventMapName, eventMap

  wireUpEvents: (EventAdapter, angularModule, APP, eventMappings) ->
    for modName, eventMapping of eventMappings
      events = []
      for eventMapName, eventMap of eventMapping.eventMaps
        events.push eventMap

      if eventMapping.flipAddListenerArgs #this is a hack for the desktopsharing module
        eventMapping.callbacks = EventAdapter.wireUpEventsReverse APP[modName], events...
      else
        eventMapping.callbacks = EventAdapter.wireUpEvents APP[modName], events...

  clearEvents: (EventAdapter, eventMappings) ->
    for modName, eventMaping of eventMappings
      EventAdapter.clearEvents mod, eventMapping.callbacks

module.exports = AngularServiceGenerator
