'use strict'

app = require '../src/jitsi/app'

describe 'angular-jitsi-meet', ->
  mockAppModule = undefined
  jmModule = undefined
  
  beforeEach ->
    jmModule = require '../src/index'
  
  it 'should be able to inject the jitsiApp service', (done) ->
    angular.mock.module jmModule
    
    inject (jitsiApp) ->
      expect(jitsiApp).to.deep.equal app
      done()

  it 'should be able to inject the settings service in an angular module', (done) ->
    angular.mock.module jmModule

    inject (settings) ->
      expect(settings).to.deep.equal app.settings
      done()
      
  describe 'using a specific jitsi module', ->
    xmpp = null
    
    beforeEach ->
      angular.mock.module jmModule
      inject (_xmpp_) ->
        xmpp = _xmpp_
    
    it 'should be able to get the connection from xmpp', ->
      isConnected = (xmpp.getConnection() != null && xmpp.getConnection().connected)
      expect(isConnected).to.equal false
    