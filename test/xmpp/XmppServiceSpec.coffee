'use strict'

describe 'Xmpp Service', ->

  XmppService = undefined
  sandbox = undefined
  $rootScope = undefined
  $log = undefined
  XMPP = undefined
  APP = 'bogus'
  config = 'bogus'

  beforeEach module('jm.xmpp')
  beforeEach ->
    sandbox = sinon.sandbox.create()
    $rootScope = sandbox.stub()
    $log = sandbox.stub()

    XMPP = sandbox.stub()
    #   "getConnection"
    #   "eject"
    #   "isModerator"
    #   "disposeConference"
    #   "removeListener"
    #   "addListener"
    #   "setMute"
    #   "start"

    module ($provide) ->
      $provide.value "$rootScope", $rootScope
      $provide.value "$log", $log
      $provide.value "XMPP", XMPP
#      $provide.value "APP", APP
#      $provide.value "config", config
      return
      
  beforeEach inject((_XmppService_, _APP_, _config_) ->
    XmppService = _XmppService_
    APP = _APP_
    config = _config_
  )

  afterEach ->
    sandbox.restore()

  describe 'isConnected', ->

    it 'should invoke XMPP.getConnection', ->
      
      
      XmppService.isConnected()

  describe 'when invoking start', ->

    it 'should set userInfo values', ->
    
    it 'should invoke setupListeners', ->

    it 'should invoke XMPP.start', ->