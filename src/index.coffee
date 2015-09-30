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
    AngularServiceGenerator.wrapInAngular ajmModule, mod, modName, eventMappings[modName]

#Wrap the jitsi APP object in angular
ajmModule.factory 'jitsiApp', ->
  APP

module.exports = ajmModule.name