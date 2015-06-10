'use strict'

# global mock objects: APP, config

describe 'Member Service', ->

  sandbox = undefined
  memberService = undefined
  $rootScope = undefined
  $log = undefined
  XMPP = undefined
  MemberService = require '../../src/xmpp/MemberService'

  beforeEach angular.mock.module('mockapp')
  beforeEach ->
    sandbox = sinon.sandbox.create()

    XMPP = sandbox.stub()
    XMPP.isModerator = XMPP.getConnection = sandbox.stub()
      
  beforeEach inject((_$log_, _$rootScope_) ->
    $log = _$log_
    $rootScope = _$rootScope_
    
    memberService = MemberService($log, $rootScope, XMPP)
  )

  afterEach ->
    sandbox.restore()

  describe 'isModerator', ->
    it 'should invoke XMPP.isModerator', ->
      memberService.isModerator()
      expect(XMPP.isModerator).to.have.been.called

  describe 'isConnected', ->
    it 'should invoke XMPP.getConnection', ->
      memberService.isConnected()
      expect(XMPP.getConnection).to.have.been.called