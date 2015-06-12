'use strict'

describe 'EventAdapter', ->
  EventEmitter = window.testHelpers.events
#  console.log window.testHelpers.events
  sandbox = undefined
  EventAdapter = undefined
  $rootScope = undefined
  $log = undefined
  mockModule = undefined
  mockReverseModule = undefined
  mockInvalidModule = undefined
  eventList =
    EVENT1: 'event1'
    EVENT2: 'event2'
    EVENT3: 'event3'

  eventList2 =
    EVENT4: 'event4'
    EVENT5: 'event5'
    EVENT6: 'event6'

  beforeEach angular.mock.module(require('../../src/common').name)
  beforeEach ->
    sandbox = sinon.sandbox.create()

    mockModule = new EventEmitter()
    sandbox.spy mockModule, 'addListener'
    
    mockReverseModule =
      eventEmitter: new EventEmitter()
      addListener: (callback, eventName) ->
        @eventEmitter.addListener(eventName, callback)
    sandbox.spy mockReverseModule, 'addListener'
    
    mockInvalidModule = name: 'test'

  beforeEach inject((_EventAdapter_, _$log_, _$rootScope_) ->
    EventAdapter = _EventAdapter_
    $log = _$log_
    $rootScope = _$rootScope_
  )

  afterEach ->
    sandbox.restore()

  describe 'wireUpEvents', ->
    it 'should invoke module.addListener', ->
      EventAdapter.wireUpEvents mockModule, eventList
      mockModule.addListener.should.have.callCount Object.keys(eventList).length
    
    it 'should work with multiple lists', ->
      EventAdapter.wireUpEvents mockModule, eventList, eventList2
      mockModule.addListener.should.have.callCount Object.keys(eventList).length + Object.keys(eventList2).length
      
    it 'should work modules that reverse the add listener args', ->
      EventAdapter.wireUpEventsReverse mockReverseModule, eventList2
      mockReverseModule.addListener.should.have.callCount Object.keys(eventList2).length
      
    it 'should throw an error for modules that do not have an addListener method', ->
      sandbox.spy EventAdapter, 'wireUpEvents'
      try
        EventAdapter.wireUpEvents mockInvalidModule, eventList
      catch err
        
      expect(EventAdapter.wireUpEvents).to.have.thrown()
      
      
      
  describe 'events should propagate to angular event bus', ->
    args = []
    
    beforeEach ->
      EventAdapter.wireUpEvents mockModule, eventList, eventList2

    for eventType, eventName of eventList
      do (eventName, args) ->
        it "#{eventName} broadcast to angular with #{args.length} args", (done) ->
          $rootScope.$on eventName, (event, data...) ->
            expect(event.name).to.equal eventName
            expect(data).to.deep.equal args
            done()

          mockModule.emit eventName, args...
      args.push "arg#{args.length + 1}"

      
