'use strict'

describe 'AngularServiceGenerator', ->
  EventEmitter = window.testHelpers.events
  AngularServiceGenerator = require '../../src/common/AngularServiceGenerator'
  ServiceGenerator = undefined
  AngularService = undefined
  EventAdapter = undefined
  commonModule = undefined
  sandbox = undefined
  mockService = undefined
  $rootScope = undefined
  mockModule = undefined
  mockReverseModule = undefined
  mockEvents = undefined
  mockAppModule = undefined
  simpleEventMapping = undefined
  reverseEventMapping = undefined
  complexEventMapping = undefined

  beforeEach ->
    commonModule = require('../../src/common')
    angular.mock.module commonModule
    mockAppModule = angular.module 'mockapp', [commonModule]
  
  beforeEach ->
    sandbox = sinon.sandbox.create()
    
    mockModule = new EventEmitter()
    mockModule.start = sandbox.stub()
    sandbox.spy mockModule, 'addListener'

    mockReverseModule =
      eventEmitter: new EventEmitter()
      addListener: (callback, eventName) ->
        @eventEmitter.addListener(eventName, callback)
      emit: (eventName, callback) ->
        @eventEmitter.emit eventName, callback
    sandbox.spy mockReverseModule, 'addListener'
    
    mockEvents =
      EVENT1: 'event1'
      EVENT2: 'event2'

    TestEvents =
      EVENT1: "evt1"
      EVENT2: "evt2"
      EVENT3: "evt3"

    OtherEvents =
      Event5: "evt5"
      Event6: "evt6"

    simpleEventMapping =
      eventMaps:
        MockEvents: mockEvents

    reverseEventMapping =
      eventMaps:
        MockEvents: mockEvents
      flipAddListenerArgs: true
    
    complexEventMapping =
      eventMaps:
        TestEvents: TestEvents
        OtherEvents: OtherEvents

  afterEach ->
    sandbox.restore()
        
  describe 'wrapInAngular', ->
    angularModule = undefined
    
    describe 'the happy path', ->
      beforeEach ->
        angularModule = getService()
        angular.mock.module mockAppModule.name
  
      it 'should return the angular module name', ->
        expect(angularModule.name).to.equal mockAppModule.name
        
      describe 'injecting the generated service', ->
        mockService
        beforeEach inject (_mock_) ->
          mockService = _mock_

        it 'calling service.start should invoke mockModule.start', ->
          mockService.start()
          expect(mockModule.start).to.have.been.called
  
        it 'calling service.addListener should invoke mockModule.addListener', ->
          callback = ->
          mockService.addListener mockEvents.EVENT1, callback
          expect(mockModule.addListener).to.have.been.calledWith mockEvents.EVENT1, callback
          
      it 'should be able to load the angular module', ->
        sandbox.spy angular, 'module'
        try
          angular.module angularModule.name
        catch err
          
        angular.module.should.not.have.thrown()

    describe 'Invalid wrapInAngular call', ->
      it 'should throw an exception', ->
        sandbox.spy AngularServiceGenerator, 'wrapInAngular'
        try
          AngularServiceGenerator.wrapInAngular()
        catch err

        expect(AngularServiceGenerator.wrapInAngular).to.have.thrown()
  
  describe 'makeEventConstants', ->
    beforeEach ->
      AngularServiceGenerator.makeEventConstants mockAppModule, complexEventMapping
      angular.mock.module mockAppModule.name
      
    it 'should be able to inject event type constant', ->
      inject (TestEvents, OtherEvents) ->
        expect(TestEvents).to.deep.equal complexEventMapping.eventMaps.TestEvents
        expect(OtherEvents.Event5).to.equal complexEventMapping.eventMaps.OtherEvents.Event5


  describe 'wireUpEvents', ->
    beforeEach ->
      getService()
      angular.mock.module mockAppModule.name

      inject (_EventAdapter_) ->
        EventAdapter = _EventAdapter_
      AngularServiceGenerator.wireUpEvents EventAdapter, mockAppModule, mockModule, simpleEventMapping
      
      
    it 'events should be wired up', (done) ->
      inject((mock) ->
        expect(Object.keys(mock._events).length).to.equal Object.keys(mockModule._events).length
        expect(Object.keys(mock._events).length).to.equal Object.keys(mockEvents).length
        done()
      )

    it 'angular event bus will receive an emitted event', (done) ->
      verifyEvent done
      
    it 'should work with a module with backwards arguments', (done) ->
      getService mockReverseModule, 'mockReverse'
      AngularServiceGenerator.wireUpEvents EventAdapter, mockAppModule, mockReverseModule, reverseEventMapping
      verifyEvent done, mockReverseModule
      
  describe 'clearEvents', ->
    beforeEach ->
      getService()
      angular.mock.module mockAppModule.name

      inject (_EventAdapter_) ->
        EventAdapter = _EventAdapter_
      AngularServiceGenerator.wireUpEvents EventAdapter, mockAppModule, mockModule, complexEventMapping
      AngularServiceGenerator.clearEvents EventAdapter, complexEventMapping, mockModule

    it "should not have any events left", ->
     expect(Object.keys(mockModule._events).length).to.equal 0
  
  #Helpers
  getService = (mod, name) ->
    mod = mockModule if not mod
    name = 'mock' if not name
    AngularServiceGenerator.wrapInAngular mockAppModule, mod, name
      
  verifyEvent = (done, mod) ->
    data = 1
    inject ($rootScope) ->
      $rootScope.$on mockEvents.EVENT1, (event, value) ->
        expect(event.name).to.equal mockEvents.EVENT1
        expect(value).to.equal data
        done()
    
    if not mod
      mod = mockModule
        
    mod.emit mockEvents.EVENT1, data
