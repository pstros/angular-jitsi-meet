var angular = require('angular');
require('angular-jitsi-meet');
// or: require('angular-jitsi-meet/lib/xmpp');

angular
    .module('app', ['jm.xmpp'])
    .controller('AppCtrl', AppCtrl);

AppCtrl.$inject = ['XmppService'];

function AppCtrl(XMPP) {
    //Use the XMPP module here
}