'use strict'

# global mock objects: APP, Strophe, config

describe 'Xmpp Service', ->

  sandbox = undefined
  XmppService = undefined
  $rootScope = undefined
  $log = undefined
  XMPP = undefined

  beforeEach module('jm.xmpp')
  beforeEach ->
    sandbox = sinon.sandbox.create()

    XMPP = sandbox.stub()
    XMPP.isModerator = ->

    module ($provide) ->
      $provide.value "XMPP", XMPP
      return
      
  beforeEach inject((_XmppService_, _$log_, _$rootScope_) ->
    XmppService = _XmppService_
    $log = _$log_
    $rootScope = _$rootScope_
  )

  afterEach ->
    sandbox.restore()

  describe 'isModerator', ->

    it 'should invoke XMPP.isModerator', ->
      sandbox.stub(XMPP, 'isModerator').returns true

      expect(XmppService.isModerator()).to.be.true
