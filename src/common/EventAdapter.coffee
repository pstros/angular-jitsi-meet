module.exports = ($log, $rootScope) ->
  EventAdapter =
    wireUpEvents: (module, events) ->
      for eventType, eventName of events
        $log.info "Registering #{eventType} events with angular event bus"
        module.addListener eventName, (args...) ->
          $rootScope.$broadcast eventName, args...

  EventAdapter
  