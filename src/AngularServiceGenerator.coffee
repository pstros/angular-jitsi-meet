'use strict'

class AngularServiceGenerator
  angularModulePrefix = 'jm'
  ###
    Creates an angular service which wraps module and wires up events from options.eventMaps. It also creates
    angular constants for each list of events.
    * Assumes that options.eventMaps is an object with keys being the angular constant name and value being an object of
    key value pairs of events.  See ModuleDefinitions.coffee for an example

    @input moduleObject
    @input moduleName
    @input options - an object with eventMaps, dir, and flipAddListenerArgs properties. All are optional
    @returns angularModuleName
  ###
  wrapInAngular: (moduleObject, moduleName, options)->
    if !moduleObject or !moduleName
      throw Error 'module and moduleName are required parameters'
    
    options = {} if !options
    options.dir = moduleName if !options.dir
    options.eventMaps = [] if !options.eventMaps
    
    angularModuleName = "#{angularModulePrefix}.#{options.dir}"
    angularServiceName = "#{moduleName}Service"

    console.log "Creating angular service #{angularServiceName} in #{angularModuleName} for jitsi meet #{moduleName} module"

    commonModule = require './common'
    angularModule = angular.module angularModuleName, [commonModule.name]

    if options?.eventMaps?.length == 0
      angularModule.factory angularServiceName, [ -> moduleObject ] #create a service with no events registered
    else
      eventMaps = []
      for eventMapName, eventMap of options.eventMaps
        console.info "Creating angular constant #{eventMapName} in #{angularModuleName}"
        angularModule.constant eventMapName, eventMap
        eventMaps.push eventMap
        
      serviceFunction = @getModuleWrapperFunction(moduleObject, moduleName, options, eventMaps)

      angularModule.factory angularServiceName, [
        'EventAdapter'
        serviceFunction
      ]

    angularModuleName
    
  getModuleWrapperFunction: (moduleObject, moduleName, options, eventMapArray) ->
    (EventAdapter) ->
      console.info "Setting up #{moduleName} module event listeners with angular"
      if options.flipAddListenerArgs #this is a hack for the desktopsharing module
        EventAdapter.wireUpEventsReverse moduleObject, eventMapArray...
      else
        EventAdapter.wireUpEvents moduleObject, eventMapArray...
      moduleObject

module.exports = new AngularServiceGenerator()