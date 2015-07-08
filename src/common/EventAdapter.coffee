module.exports = ($log, $rootScope) ->
  registerEventListener = (moduleObject, reverseArgs, eventType, eventName) ->
    if typeof moduleObject.addListener != 'function'
      throw new Exception "Unable to register events, the module doesn't have an add listener function."
      
#    $log.debug "Registering #{eventType} events with angular event bus"
    callback = (args...) ->
      $rootScope.$apply ->
        $rootScope.$broadcast eventName, args...
      

    #this is an ugly hack because of the desktopsharing module in jitsi-meet
    if reverseArgs
      moduleObject.addListener callback, eventName
    else
      moduleObject.addListener eventName, callback
    
  registerEventListeners = (mod, reverseArgs, eventMap) ->
    for eventType, eventName of eventMap
      registerEventListener mod, reverseArgs, eventType, eventName

  EventAdapter =
    wireUpEvents: (moduleObject, eventMaps...) ->
      for eventMap in eventMaps
        registerEventListeners moduleObject, false, eventMap
        
    wireUpEventsReverse: (moduleObject, eventMaps...) ->
      for eventMap in eventMaps
        registerEventListeners moduleObject, true, eventMap
  EventAdapter
  