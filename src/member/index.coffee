'use strict'

#ModDefs = require '../ModuleDefinitions'
#mod = ModDefs.xmpp
#mod.name = 'xmpp'

name = "jm.member"
commonModule = require '../common'
angularModule = angular.module name, [commonModule.name]
      
#serviceGenerator = require '../AngularServiceGenerator'
#serviceGenerator.wrapInAngular mod.module, mod.name, mod.options

angularModule.factory 'MemberService', [
  '$log'
  '$rootScope'
  'XMPPService'
  require './MemberService'
]

module.exports = name: name