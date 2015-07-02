var angular = require('angular');

//Mock objects that jitsi-meet xmpp module depends on
config = {
    hosts: {}
};
interfaceConfig = {};
Strophe = {};
APP = {
    UI: {
        checkForNickNameAndJoin: function() {}
    }
};

jm = require('angular-jitsi-meet');

angular.module('app', ['ajmAll', 'ajmPartial']);

angular
    .module('ajmAll', [jm.name])
    .controller('AppCtrl', AppCtrl);

angular
    .module('ajmPartial',
    [jm.API.name,
     jm.connectionquality.name,
     jm.desktopsharing.name,
     jm.DTMF.name,
     jm.keyboardshortcut.name,
     jm.members.name,
     jm.RTC.name, 
     jm.Settings.name,
     jm.statistics.name,
     jm.translation.name,
     jm.URLProcessor.name,
     jm.xmpp.name])
    .controller('AppCtrl2', AppCtrl);

AppCtrl.$inject = ['API', 'connectionquality', 'desktopsharing', 'DTMF', 
    'keyboardshortcut','members', 'RTC', 'Settings',
    'statistics', 'translation', 'URLProcessor', 'xmpp'];

function AppCtrl(API, connectionquality, desktopsharing, DTMF, 
                 keyboardshortcut, members, RTC, Settings,
                 statistics, translation, URLProcessor, xmpp) {
    app = this;
    app.xmpp = xmpp;
    app.isConnected = (xmpp.getConnection() != null && xmpp.getConnection().connected);

//    this.UI = require("./modules/UI/UI");
    APP.API = API;
    APP.connectionquality = connectionquality;
    APP.statistics = statistics;
    APP.RTC = RTC;
    APP.desktopsharing = desktopsharing;
    APP.xmpp = xmpp;
    APP.keyboardshortcut = keyboardshortcut;
    APP.translation = translation;
    APP.settings = Settings;
    APP.DTMF = DTMF;
    APP.members = members;
    APP.URLProcessor = URLProcessor;
}

module.exports = APP;