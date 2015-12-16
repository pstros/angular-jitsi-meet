'use strict'

app = require '../src/jitsi/app'

describe 'angular-jitsi-meet', ->
  mockAppModule = undefined
  jmModule = undefined

  beforeEach ->
    jmModule = require '../src/index'

  it 'should be able to use the jitsiApp service', (done) ->
    angular.mock.module jmModule

    inject (jitsiApp) ->
      expect(jitsiApp).to.deep.equal app
      done()

  describe 'using a specific jitsi module', ->
    it 'should be able to use the settings service in an angular module', (done) ->
      angular.mock.module jmModule

      inject (settings) ->
        expect(settings).to.deep.equal app.settings
        done()
