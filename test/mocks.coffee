# Mock objects that jitsi-meet xmpp module depends on

window.config =
  hosts: {}

window.Strophe = {}

window.APP =
  UI:
    checkForNicknameAndJoin: ->
      
angular.module 'mockapp', []
      
window.testHelpers =
  events: require 'events'
