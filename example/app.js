var angular = require('angular');

//Mock objects that jitsi-meet xmpp module depends on
config = {
    hosts: {}
};
Strophe = {};
APP = {
    UI: {
        checkForNickNameAndJoin: function() {}
    }
};

require('angular-jitsi-meet');
// or: require('angular-jitsi-meet/angular/xmpp');


angular
    .module('app', ['jm.xmpp', 'jm.desktopsharing'])
    .controller('AppCtrl', AppCtrl);

AppCtrl.$inject = ['XMPPService', 'desktopsharingService'];

function AppCtrl(XMPP, desktopSharingService) {
    app = this;
    app.XMPP = XMPP;
    app.isConnected = (XMPP.getConnection() != null && XMPP.getConnection().connected);

    APP.XMPP = XMPP;
    APP.desktopsharing = desktopSharingService;
}

module.exports = APP;