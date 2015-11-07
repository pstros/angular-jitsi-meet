var angular = require('angular');

//$ = require("jquery");
require("strophe");
require("angular-jitsi-meet/node_modules/jitsi-meet/libs/strophe/strophe.disco.min.js");
require("angular-jitsi-meet/node_modules/jitsi-meet/libs/strophe/strophe.caps.jsonly.min.js");

//Load the config(s) that jitsi-meet needs
//TODO: make these work as requires (browserify shim)
//require('angular-jitsi-meet/node_modules/jitsi-meet/config.js');
//require('angular-jitsi-meet/node_modules/jitsi-meet/interface_config.js');

//Override config properties for testing
config = {};
config.hosts = {
  domain: 'meet.jit.si',
  muc: 'conference.meet.jit.si',
};
config.video = {};
config.bosh = 'https://meet.jit.si/http-bind';

jitsiMeet = require('angular-jitsi-meet');

angular
    .module('app', [jitsiMeet])
    .controller('JitsiAppCtrl', JitsiAppCtrl)
    .factory('conferenceService', ConferenceService)
    .factory('memberService', MemberService)
    .factory('streamService', StreamService);

//This controller joins a room and then leaves after 30 seconds
//It also exposes data to the view
function JitsiAppCtrl($timeout, conferenceService, memberService, streamService) {
  var vm = this;

  var roomName = "AJMTestRoom";
  var displayName = "AJM Test User";

  conferenceService.joinRoom(roomName, displayName);
  vm.isConnected = true;
  vm.roomName = conferenceService.getRoomName();
  vm.streams = function() {
    return streamService.getAllStreams();
  };
  vm.members = function() {
    return memberService.getMembers();
  };

  $timeout(function () {
    conferenceService.leaveRoom();
    vm.isConnected = false;
    console.log("Leaving room");
  }, 30000);
}

/**
 * Conference service is responsible for joining/leaving the room and starting/stopping other services
 */
function ConferenceService($rootScope, jitsiApp, settings, xmpp, XMPPEvents, RTC, memberService, streamService) {
  var scopeListeners = [];
  var joinTimeoutInstance = null;
  var roomName = null;
  var logoutInProgress = false;
  var alreadyRun = false;

  function addListeners() {
    scopeListeners.push($rootScope.$on(XMPPEvents.READY_TO_JOIN, onReadyToJoin));
  }

  function cleanupListeners() {
    while(a = scopeListeners.pop()) {
      a();
    }
  }

  function joinRoom(roomToJoin, displayName) {
    addListeners();
    memberService.start();
    streamService.start();
    setRoomName(roomToJoin);
    settings.setDisplayName(displayName);
    jitsiApp.startJitsiServices(getUserJid(), null, false);
  }

  function setRoomName(newRoomName) {
    roomName = newRoomName.toLowerCase();
    updateBoshUrl(roomName);
  }

  function updateBoshUrl(roomName) {
    if(!config.oldBosh) {
      config.oldBosh = config.bosh;
    }
    config.bosh = config.oldBosh + "?room=" + roomName; //hack since we haven't pulled in the latest jitsi-meet yet
  }

  function onReadyToJoin() {
    if (!alreadyRun) { //This is to guard against the case where get user media resolves after the xmpp connection is set up
      alreadyRun = true;

      xmpp.allocateConferenceFocus(getRoomJid(), onFocusAllocated);
    }
  }

  function onFocusAllocated() {
    xmpp.joinRoom(getRoomJid());
  }


  function leaveRoom() {
    var connection = xmpp.getConnection();

    if (connection && connection.connected && !logoutInProgress) {
      logoutInProgress = true;
      xmpp.logout(function () {
        cleanup();
      });
    } else {
      cleanup();
    }
  }

  function cleanup() {
    cleanupJitsi();
    memberService.stop();
    streamService.stop();
    cleanupListeners();
    alreadyRun = false;
    roomName = null;
    logoutInProgress = false;
  }

  function cleanupJitsi() {
    RTC.setVideoMute(true, function () {
    });
    xmpp.setAudioMute(true, function () {
    });
    xmpp.disposeConference(true);
    xmpp.getConnection().disconnect();
    xmpp.stop();
    jitsiApp.clearEvents();
    jitsiApp.stopJitsiServices();
  }


  //Helpers
  function getRoomJid() {
    return encodeURIComponent(roomName.toLowerCase()) + "@" + config.hosts.muc;
  }

  function getUserJid() {
    return config.hosts.domain;
  }

  function getRoomName() {
    return roomName;
  }

  return {
    joinRoom: joinRoom,
    leaveRoom: leaveRoom,
    getRoomName: getRoomName
  };
}

/**
 * Member service holds an object with keys for each member in the meeting at the current time
 */
function MemberService($rootScope, XMPPEvents) {
  var members = {};
  var listeners = [];

  function addListeners() {
    listeners.push($rootScope.$on(XMPPEvents.MUC_MEMBER_JOINED, onMemberJoined));
    listeners.push($rootScope.$on(XMPPEvents.MUC_MEMBER_LEFT, onMemberLeft));
  }

  function cleanupListeners() {
    while(a = listeners.pop()) {
      a();
    }
  }

  function onMemberJoined(event, jid, id, displayName) {
    var member = {
      jid: jid,
      id: id,
      displayName: displayName
    };
    members[jid] = member;
  }

  function onMemberLeft(event, jid) {
    delete members[jid];
  }

  return {
    start: function() { addListeners(); },
    stop: function() {
      cleanupListeners();
      memebers = {};
    },
    getMemberByJid: function(jid) {
      return members[jid];
    },
    getSize: function() {
      return Object.keys(members).length;
    },
    getMembers: function() {
      return members;
    }
  };
}

/**
 * StreamService stores the audio/video streams by member jid
 */
function StreamService($rootScope, StreamEventTypes) {
  var streams = {};
  var listeners = [];
  var localJid = 'local';

  function localStreamHandler(event, stream, isMuted) {
    streamHandler(localJid, stream);
  }

  function remoteStreamHandler(event, stream) {
    if(typeof stream.peerjid != 'undefined' && stream.peerjid) {
      streamHandler(stream.peerjid, stream);
    }
  }

  function streamHandler(jid, stream) {
    if(!streams.hasOwnProperty(jid)) {
      streams[jid] = {
        jid: jid,
        audioStream: null,
        videoStream: null,
        local: jid == localJid
      };
    }
    console.log("Processing stream with type: " + stream.type.toLowerCase());
    switch(stream.type.toLowerCase()) {
      case 'audio':
        streams[jid].audioStream = stream;
        break;
      case 'video':
      case 'screen':
        streams[jid].videoStream = stream;
        break;
    }
  }

  function addListeners() {
    listeners.push($rootScope.$on(StreamEventTypes.EVENT_TYPE_LOCAL_CREATED, localStreamHandler));
    listeners.push($rootScope.$on(StreamEventTypes.EVENT_TYPE_LOCAL_CHANGED, localStreamHandler));
    listeners.push($rootScope.$on(StreamEventTypes.EVENT_TYPE_REMOTE_CREATED, remoteStreamHandler));
  }

  function cleanupListeners() {
    while(a = listeners.pop()) {
      a();
    }
  }

  return {
    start: function() { addListeners(); },
    stop: function() {
      cleanupListeners();
      streams = {};
    },
    getAllStreams: function() { return streams; },
    getStreamsForJid: function (jid) { streams[jid]; }
  };
}