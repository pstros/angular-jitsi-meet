'use strict'

###global APP, config, ionicConfig###

module.exports = ($log, $rootScope) ->
  XMPP = require 'jitsi-meet/modules/xmpp/xmpp'
  userInfo =
    nick: ''
    email: ''
    roomName: ''
    uid: ''
  members = {}

  init = ->
    #This fn is called just before the service is returned, place setup things here
    APP.UI.checkForNicknameAndJoin = checkForNicknameAndJoin
    userInfo.uid = generateUniqueId()
    return

  generateUniqueId = ->

    _p8 = ->
      (Math.random().toString(16) + '000000000').substr 2, 8

    _p8() + _p8() + _p8() + _p8()

  eventLogger = (event) ->
    $log.debug 'Event came in: ' + event
    return

  checkForNicknameAndJoin = ->
    #Called from the maybeDoJoin function in the jitsi XMPP.js file
    #Since we have no access to the settings object we call those methods here:
    if userInfo.email
      XMPP.getConnection().emuc.addEmailToPresence userInfo.email
    if userInfo.nick
      XMPP.getConnection().emuc.addDisplayNameToPresence userInfo.nick
    XMPP.getConnection().emuc.addUserIdToPresence userInfo.uid
    $log.debug 'Connecting to room: ' + userInfo.roomName + ' with nick: ' + userInfo.nick
    XMPP.getConnection().rawInput = eventLogger
    XMPP.joinRoom userInfo.roomName, config.useNicks, userInfo.nick
    return

  isConnected = ->
    XMPP.getConnection() and !XMPP.getConnection().connected

  setupListeners = ->

    kickedListener = ->
      XMPP.removeListener 'xmpp.kicked', kickedListener
      $log.info 'I have been removed from conference'
      $rootScope.$broadcast 'user:kicked'
      return

    XMPP.addListener 'xmpp.kicked', kickedListener
    XMPP.addListener 'xmpp.muc_member_left', (jid) ->
      $log.debug 'User left: ' + jid
      members = XMPP.getMembers()
      $rootScope.$broadcast 'members:updated', members
      return
    XMPP.addListener 'xmpp.muc_member_joined', (jid) ->
      $log.debug 'User joined: ' + jid
      members = XMPP.getMembers()
      $rootScope.$broadcast 'members:updated', members
      return
    return

  start = (inRoomName, inNick) ->
    userInfo.nick = inNick
    userInfo.email = inRoomName
    userInfo.roomName = inRoomName.replace('@', '.') + '@' + config.hosts.muc
    $log.debug 'Setting room to: ' + userInfo.roomName + ' and nick to: ' + userInfo.nick
    setupListeners()
    $log.debug 'Connecting to ' + config.bosh
    if ionicConfig.configLoaded
      XMPP.start()
    else
      ionicConfig.onConfigLoadedListeners.push XMPP.start
    return

  logout = ->
    XMPP.disposeConference()
    return

  setMute = (jid, mute) ->
    XMPP.setMute jid, mute
    return

  eject = (jid) ->
    XMPP.eject jid
    return

  isModerator = ->
    XMPP.isModerator()

  init()
  {
    start: start
    isConnected: isConnected
    participants: members
    userInfo: userInfo
    logout: logout
    setMute: setMute
    eject: eject
    isModerator: isModerator
  }
