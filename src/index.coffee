'use strict'

jitsiModules = [
  dir: 'settings'
  name: 'Settings'
  module: require 'jitsi-meet/modules/settings/Settings'
#,
#  name: 'simulcast'
#  module: require 'jitsi-meet/modules/simulcast/simulcast'
,
  name: 'desktopsharing'
  module: require 'jitsi-meet/modules/desktopsharing/desktopsharing'
  deps:
    DesktopSharingEventTypes: require 'jitsi-meet/service/desktopsharing/DesktopSharingEventTypes'
  flipAddListenerArgs: true
#,
#  name: 'RTC'
#  deps: {}
]

jitsiModules.forEach (mod)->
  console.log "Creating angular #{mod.name} module"

  mod.dir = mod.name if !mod.dir
  mod.deps = [] if !mod.deps

  angularModuleName = "jm.#{mod.dir}"

  modulePath = "jitsi-meet/modules/#{mod.dir}"
  servicePath = "jitsi-meet/service/#{mod.dir}"

  commonModule = require './common'
  angularModule = angular.module angularModuleName, [commonModule.name]

  if mod?.deps?.length == 0
    angularModule.factory "#{mod.name}Service", [
      ->
        mod.module
#        require "#{modulePath}/#{mod.name}"
    ]
  else
    depArray = []
    for depName, dep of mod.deps
      angularModule.constant depName, dep
      depArray.push dep

    angularModule.factory "#{mod.name}Service", [
      'EventAdapter'
      (EventAdapter) ->
        service = mod.module
#        service = require "#{modulePath}/#{mod.name}"
        EventAdapter.wireUpEvents mod, depArray...
        service
    ]

#module.exports = name: name