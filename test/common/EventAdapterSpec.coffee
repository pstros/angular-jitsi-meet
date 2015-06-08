'use strict'

describe 'EventAdapter', ->
  sandbox = undefined
  EventAdapter = undefined
  $rootScope = undefined
  $log = undefined
  mockModule = undefined
  eventList = undefined

  beforeEach module('jm.common')
  beforeEach ->
    sandbox = sinon.sandbox.create()

    mockModule = sandbox.stub()
    mockModule.addListener = sandbox.stub()
    
    eventList =
      EVENT1: 'event1'
      EVENT2: 'event2'
      EVENT3: 'event3'

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
      
  describe 'firing an event', ->
    it 'should call $rootScope.broadcast', (done) ->
      evt =
        name: 'event1'
        arg: 1

      mockModule.addListener.callsArgWith 1, evt.arg
      
      $rootScope.$on evt.name, (event, arg) ->
        expect(event.name).to.equal evt.name
        expect(arg).to.equal evt.arg
        done()

      EventAdapter.wireUpEvents mockModule, {EVENT1: evt.name}
