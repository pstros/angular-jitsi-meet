'use strict'

jitsiModules = require './ModuleDefinitions'
ajmModulePrefix = 'jm'
ajmDeps = []
modules = {}

serviceGenerator = require './AngularServiceGenerator'
for modName, mod of jitsiModules
  if modName is 'name' or modName is 'module'
    throw Error 'The module name cannot be "name" or "module"'
  
  angularModule = serviceGenerator.wrapInAngular mod.module, modName, mod.options
  ajmDeps.push angularModule.name
  modules[modName] = angularModule

ajmAngularModule = angular.module ajmModulePrefix, ajmDeps

modules.name = ajmAngularModule.name
modules.module = ajmAngularModule.module

module.exports = modules
