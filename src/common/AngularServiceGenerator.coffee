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
  wrapInAngular: (angularModule, moduleObject, serviceName)->
    if !moduleObject or !serviceName
      throw Error 'moduleObject and serviceName are required parameters'

    console.debug "Creating angular service #{serviceName} in #{angularModule.name}"

    angularModule.factory serviceName, [ -> moduleObject ] #create a service with no events registered

    angularModule

  makeEventConstants: (angularModule, eventMapping) ->
    for eventMapName, eventMap of eventMapping.eventMaps
      console.debug "Creating angular constant #{eventMapName} in #{angularModule.name}"
      angularModule.constant eventMapName, eventMap

  wireUpEvents: (EventAdapter, angularModule, moduleObject, eventMapping) ->
    events = []
    for eventMapName, eventMap of eventMapping?.eventMaps
      events.push eventMap

    if not eventMapping?.callbacks
      eventMapping.callbacks = []

    if eventMapping.flipAddListenerArgs #this is a hack for the desktopsharing module
      eventMapping.callbacks.push EventAdapter.wireUpEventsReverse moduleObject, events...
    else
      eventMapping.callbacks.push EventAdapter.wireUpEvents moduleObject, events...

  clearEvents: (EventAdapter, eventMapping, moduleObject) ->
    if eventMapping?.callbacks
      for callback in eventMapping.callbacks
        EventAdapter.clearEvents moduleObject, callback

module.exports = AngularServiceGenerator
