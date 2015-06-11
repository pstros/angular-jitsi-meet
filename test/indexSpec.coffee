'use strict'

modDefs = require '../src/ModuleDefinitions'#window.jitsiModuleDefs

describe 'angular-jitsi-meet', ->
  mockAppModule = undefined
  jmModule = undefined
  
  beforeEach ->
    jmModule = require '../src/index'#, {
#      './ModuleDefinitions': modDefs
#    }
  
  it 'should be able to be used in a mock module', (done) ->
    angular.mock.module jmModule.name
    
    inject (Settings) ->
#      expect(Settings).to.be.defined
      expect(Settings).to.deep.equal modDefs.Settings.module
      done()