'use strict'

jitsiModules = require './ModuleDefinitions'
angularJitsiModules = []

serviceGenerator = require './AngularServiceGenerator'
for modName, mod of jitsiModules
  angularJitsiModules.push serviceGenerator.wrapInAngular mod.module, modName, mod.options

ajmModule = angular.module 'jm', angularJitsiModules
  
module.exports = ajmModule