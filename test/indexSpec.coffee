'use strict'

modDefs = require '../src/ModuleDefinitions'

describe 'angular-jitsi-meet', ->
  mockAppModule = undefined
  jmModule = undefined
  
  beforeEach ->
    jmModule = require '../src/index'
  
  it 'should be able to be used in a mock module', (done) ->
    angular.mock.module jmModule.name
    
    inject (Settings) ->
      expect(Settings).to.deep.equal modDefs.Settings.module
      done()
      
  describe 'loading a specific jitsi module', ->
    it 'should be able to load the jm.Settings module', (done) ->
      angular.mock.module jmModule.Settings.name

      inject (Settings) ->
        expect(Settings).to.deep.equal modDefs.Settings.module
        done()