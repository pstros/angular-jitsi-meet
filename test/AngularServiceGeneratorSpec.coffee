'use strict'

describe 'AngularServiceGenerator', ->
  EventEmitter = window.testHelpers.events
  ServiceGenerator = require '../src/AngularServiceGenerator'
  AngularService = undefined
  EventAdapter = undefined
  sandbox = undefined
  mockService = undefined
  $rootScope = undefined
  mockModule = undefined
  mockReverseModule = undefined
  mockEvents = undefined
  mod = undefined
  modReverse = undefined
  modNoOpts = undefined

  beforeEach angular.mock.module 'mockapp'
  beforeEach angular.mock.module require('../src/common').name
  
  beforeEach ->
    sandbox = sinon.sandbox.create()
    
    mockModule = new EventEmitter()
    mockModule.start = sandbox.stub()
    sandbox.spy mockModule, 'addListener'

    mockReverseModule =
      eventEmitter: new EventEmitter()
      addListener: (callback, eventName) ->
        @eventEmitter.addListener(eventName, callback)
    sandbox.spy mockReverseModule, 'addListener'
    
    mockEvents =
      EVENT1: 'event1'
      EVENT2: 'event2'
    
    mod =
      module: mockModule
      name: 'mock'
      options:
        eventMaps:
          MockEvents: mockEvents
          
    modNoOpts =
      module: mockModule
      name: 'mockNoOpts'

    modReverse =
      module: mockModule
      name: 'mockReverse'
      options:
        flipAddListenerArgs: true

  afterEach ->
    sandbox.restore()

  describe 'getModuleWrapperFunction', ->
    beforeEach inject((_EventAdapter_) ->
      EventAdapter = _EventAdapter_
    )
    
    AngularService = undefined
    
    beforeEach ->
      AngularService = ServiceGenerator.getModuleWrapperFunction mod.module, mod.name, mod.options, [mockEvents]
    
    it 'is a function', ->
      expect(typeof AngularService).to.equal 'function'
    
    describe 'instantiate angular service instance', ->
      callback = undefined
      
      beforeEach ->
        mockService = AngularService EventAdapter
        callback = (args...) ->
      
      it 'calling service.start should invoke mockModule.start', ->
        mockService.start()
        expect(mockModule.start).to.have.been.called

      it 'calling service.addListener should invoke mockModule.addListener', ->
        mockService.addListener mockEvents.EVENT1, callback
        expect(mockModule.addListener).to.have.been.calledWith mockEvents.EVENT1, callback

      it 'event handlers should be registered only once', ->
        expect(Object.keys(mockModule._events).length).to.equal Object.keys(mockEvents).length
        mockService = AngularService EventAdapter
        expect(Object.keys(mockModule._events).length).to.equal Object.keys(mockEvents).length

      it 'angular event bus will receive an emitted event', (done) ->
        verifyEvent done
        
  describe 'wrapInAngular', ->
    angularModule = undefined
    
    beforeEach ->
      angularModule = getService mod

    it 'should return the module name', ->
      expect(angularModule.name).to.equal "jm.#{mod.name}"
    
    it 'should be able to load the angular module', ->
      sandbox.spy angular, 'module'
      try
        angular.module angularModule.name
      catch err
        
      angular.module.should.not.have.thrown()
    
    it 'events should be wired up', (done) ->
      angular.mock.module angularModule.name
      
      inject((mock) ->
        expect(Object.keys(mock._events).length).to.equal Object.keys(mockModule._events).length
        expect(Object.keys(mock._events).length).to.equal Object.keys(mockEvents).length
        done()
      )

  describe 'Invalid wrapInAngular call', ->
    it 'should throw an exception', ->
      sandbox.spy ServiceGenerator, 'wrapInAngular'
      try
        ServiceGenerator.wrapInAngular()
      catch err
        
      expect(ServiceGenerator.wrapInAngular).to.have.thrown()
    
  describe 'test with various module configs', (done) ->
    it 'should work with a module which has backwards addListener args', ->
      service = getService modReverse
      verifyEvent done

    it 'should work with a module without any options set', ->
      service = getService modNoOpts
      expect(service.name).to.equal "jm.#{modNoOpts.name}"
      
  getService = (mod) ->
    ServiceGenerator.wrapInAngular mod.module, mod.name, mod.options
      
  verifyEvent = (done) ->
    data = 1
    inject ($rootScope) ->
      $rootScope.$on mockEvents.EVENT1, (event, value) ->
        expect(event.name).to.equal mockEvents.EVENT1
        expect(value).to.equal data
        done()

    mockModule.emit mockEvents.EVENT1, data