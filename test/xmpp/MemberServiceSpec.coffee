'use strict'

# global mock objects: APP, config

describe 'Member Service', ->

  sandbox = undefined
  MemberService = undefined
  $rootScope = undefined
  $log = undefined
  XMPP = undefined

  beforeEach module('jm.xmpp')
  beforeEach ->
    sandbox = sinon.sandbox.create()

    XMPP = sandbox.stub()
    XMPP.isModerator = XMPP.getConnection = sandbox.stub() 

    module ($provide) ->
      $provide.value "XMPPService", XMPP
      return
      
  beforeEach inject((_MemberService_, _$log_, _$rootScope_) ->
    MemberService = _MemberService_
    $log = _$log_
    $rootScope = _$rootScope_
  )

  afterEach ->
    sandbox.restore()

  describe 'isModerator', ->
    it 'should invoke XMPP.isModerator', ->
      MemberService.isModerator()
      expect(XMPP.isModerator).to.have.been.called

  describe 'isConnected', ->
    it 'should invoke XMPP.getConnection', ->
      MemberService.isConnected()
      expect(XMPP.getConnection).to.have.been.called