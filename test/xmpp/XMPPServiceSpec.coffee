'use strict'

# global mock objects: APP, config

describe 'XMPP Service', ->
  EventEmitter = window.testHelpers.events
  XMPPService = undefined
  EventAdapter = undefined
  sandbox = undefined
  xmppService = undefined
  $rootScope = undefined
  $log = undefined
  XMPP = undefined
  XMPPEvents = undefined
  eventEmitter = undefined

  beforeEach angular.mock.module 'mockapp'
  beforeEach angular.mock.module require('../../src/common').name
  beforeEach ->
    sandbox = sinon.sandbox.create()
    
    eventEmitter = new EventEmitter()

    XMPP = sandbox.stub()
    XMPP.getConnection = sandbox.stub()
    XMPP.addListener = (eventName, callback) ->
      eventEmitter.addListener eventName, callback
    sandbox.spy XMPP, 'addListener'
    
    XMPPEvents =
      EVENT1: 'event1'
      EVENT2: 'event2'

    XMPPService = require '../../src/xmpp/XMPPService',
      'jitsi-meet/modules/xmpp/xmpp': XMPP
      
  beforeEach inject((_EventAdapter_, _$log_, _$rootScope_) ->
    $log = _$log_
    $rootScope = _$rootScope_
    EventAdapter = _EventAdapter_
    
    xmppService = XMPPService(EventAdapter, XMPPEvents)
  )

  afterEach ->
    sandbox.restore()

  describe 'getConnection', ->
    it 'should invoke XMPP.getConnection', ->
      xmppService.getConnection()
      expect(XMPP.getConnection).to.have.been.called

  describe 'addListener', ->
    callback = undefined
    data = undefined
    
    beforeEach ->
      callback = (args...) ->
      data = 1

    it 'should invoke XMPP.addListener', ->
      xmppService.addListener XMPPEvents.EVENT1, callback
      expect(XMPP.addListener).to.have.been.calledWith XMPPEvents.EVENT1, callback
      
    it 'angular event bus will receive an emitted event', (done) ->
      $rootScope.$on XMPPEvents.EVENT1, (event, value) ->
        expect(event.name).to.equal XMPPEvents.EVENT1
        expect(value).to.equal data
        done()
      
      eventEmitter.emit XMPPEvents.EVENT1, data
      