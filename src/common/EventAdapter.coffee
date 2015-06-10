module.exports = ($log, $rootScope) ->
  registerEventListener = (mod, eventType, eventName) ->
    $log.info "Registering #{mod.name} #{eventType} events with angular event bus"
    callback = (args...) ->
      $rootScope.$broadcast eventName, args...

    #this is an ugly hack because of the desktopsharing module in jitsi-meet
    if mod.flipAddListenerArgs
      mod.module.addListener callback, eventName
    else
      mod.module.addListener eventName, callback
    
  registerEventListeners = (mod, eventList) ->
    for eventType, eventName of eventList
      registerEventListener mod, eventType, eventName

  EventAdapter =
    wireUpEvents: (mod, eventLists...) ->
      for eventList in eventLists
        registerEventListeners mod, eventList
  EventAdapter
  