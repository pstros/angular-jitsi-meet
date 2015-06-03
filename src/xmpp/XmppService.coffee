'use strict'

#global objects: APP, config

module.exports = ($log, $rootScope) ->
  XMPP = require 'jitsi-meet/modules/xmpp/xmpp'
  members = {}
  userInfo =
    nick: ''
    email: ''
    roomName: ''
    uid: ''

  service =
    start: start
    isConnected: isConnected
    participants: members
    userInfo: userInfo
    logout: logout
    setMute: setMute
    eject: eject
    isModerator: isModerator

  init()

  return service

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

  eventLogger = (event) ->
    $log.debug 'Event came in: ' + event
    return

  eject = (jid) ->
    XMPP.eject jid
    return

  generateUniqueId = ->
    _p8 = ->
      (Math.random().toString(16) + '000000000').substr 2, 8

    _p8() + _p8() + _p8() + _p8()

  init = ->
    #This fn is called just before the service is returned, place setup things here
    APP.UI.checkForNicknameAndJoin = checkForNicknameAndJoin
    userInfo.uid = generateUniqueId()
    return

  isConnected = ->
    XMPP.getConnection() and !XMPP.getConnection().connected

  isModerator = ->
    XMPP.isModerator()

  logout = ->
    XMPP.disposeConference()
    return

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

  setMute = (jid, mute) ->
    XMPP.setMute jid, mute
    return

  start = (inRoomName, inNick) ->
    userInfo.nick = inNick
    userInfo.email = inRoomName
    userInfo.roomName = inRoomName.replace('@', '.') + '@' + config.hosts.muc

    $log.debug 'Setting room to: ' + userInfo.roomName + ' and nick to: ' + userInfo.nick
    setupListeners()
    $log.debug 'Connecting to ' + config.bosh
    XMPP.start()
    return
