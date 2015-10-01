module.exports = ($log, $rootScope) ->
  'ngInject'

  registerEventListener = (moduleObject, reverseArgs, eventType, eventName) ->
    if typeof moduleObject.addListener != 'function'
      throw new Exception "Unable to register events, the module doesn't have an add listener function."

#    $log.debug "Registering #{eventType} events with angular event bus"
    callback = (args...) ->
      if not $rootScope.$$phase
        $rootScope.$apply ->
          $rootScope.$broadcast eventName, args...
      else
        $rootScope.$broadcast eventName, args...


    #this is an ugly hack because of the desktopsharing module in jitsi-meet
    if reverseArgs
      moduleObject.addListener callback, eventName
    else
      moduleObject.addListener eventName, callback

    callback

  registerEventListeners = (mod, reverseArgs, eventMap) ->
    callbackEventObj = {}
    for eventType, eventName of eventMap
      callbackEventObj[eventName] = registerEventListener mod, reverseArgs, eventType, eventName
    callbackEventObj

  EventAdapter =
    wireUpEvents: (moduleObject, eventMaps...) ->
      callbackEventMap = []
      for eventMap in eventMaps
        callbackEventMap.push registerEventListeners moduleObject, false, eventMap
      callbackEventMap

    wireUpEventsReverse: (moduleObject, eventMaps...) ->
      callbackEventMap = []
      for eventMap in eventMaps
        callbackEventMap.push
          eventMap: registerEventListeners moduleObject, true, eventMap
      callbackEventMap

    clearEvents: (moduleObject, callbackEventMap) ->
      for eventMap in callbackEventMap
        for eventName, callback of eventMap
          moduleObject.removeListener eventName, callback

  EventAdapter
