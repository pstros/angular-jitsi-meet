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

angular
    .module('app', ['jm', 'jm.xmpp', 'jm.desktopsharing'])
    .controller('AppCtrl', AppCtrl);

AppCtrl.$inject = ['xmppService', 'desktopsharingService', 'RTCService', 'SettingsService'];

function AppCtrl(XMPP, desktopSharingService, RTC, Settings) {
    app = this;
    app.XMPP = XMPP;
    app.isConnected = (XMPP.getConnection() != null && XMPP.getConnection().connected);

    APP.XMPP = XMPP;
    APP.desktopsharing = desktopSharingService;
    APP.Settings = Settings
    APP.RTC = RTC
}

module.exports = APP;