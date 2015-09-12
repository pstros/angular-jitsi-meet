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
  wrapInAngular: (angularModule, moduleObject, moduleName, options)->
    if !moduleObject or !moduleName
      throw Error 'module and moduleName are required parameters'
    
    options = {} if !options
    options.eventMaps = [] if !options.eventMaps

    angularServiceName = "#{moduleName}"

    console.debug "Creating angular service #{angularServiceName} in #{angularModule.name} for #{moduleName} module"

    if !moduleObject.addListener || options?.eventMaps?.length == 0
      angularModule.factory angularServiceName, [ -> moduleObject ] #create a service with no events registered
    else
      eventMaps = []
      for eventMapName, eventMap of options.eventMaps
        console.debug "Creating angular constant #{eventMapName} in #{angularModule.name}"
        angularModule.constant eventMapName, eventMap
        eventMaps.push eventMap
        
      serviceFunction = @getModuleWrapperFunction(moduleObject, moduleName, options, eventMaps)

      angularModule.factory angularServiceName, [
        'EventAdapter'
        serviceFunction
      ]

    angularModule
    
  getModuleWrapperFunction: (moduleObject, moduleName, options, eventMapArray) ->
    eventsWiredUp = false
    (EventAdapter) ->
      if !eventsWiredUp
        console.debug "Setting up #{moduleName} module event listeners for angular"
        if options.flipAddListenerArgs #this is a hack for the desktopsharing module
          EventAdapter.wireUpEventsReverse moduleObject, eventMapArray...
        else
          EventAdapter.wireUpEvents moduleObject, eventMapArray...
        eventsWiredUp = true
      moduleObject

module.exports = AngularServiceGenerator