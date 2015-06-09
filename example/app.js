var angular = require('angular');
require('angular-jitsi-meet');
// or: require('angular-jitsi-meet/angular/xmpp');

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

angular
    .module('app', ['jm.xmpp'])
    .controller('AppCtrl', AppCtrl);

AppCtrl.$inject = ['XMPPService'];

function AppCtrl(XMPP) {
    app = this;
    app.XMPP = XMPP;
    app.isConnected = (XMPP.getConnection() != null && XMPP.getConnection().connected);

    APP.XMPP = XMPP;
}

module.exports = APP;