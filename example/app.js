var angular = require('angular');

//Mock objects that jitsi-meet xmpp module depends on
config = {
    hosts: {}
};
interfaceConfig = {};
Strophe = {};

jitsiMeet = require('angular-jitsi-meet');

angular.module('app', ['ajmAll', 'ajmPartial']);

angular
    .module('ajmAll', [jitsiMeet])
    .controller('JitsiAppCtrl', JitsiAppCtrl);

function JitsiAppCtrl(jitsiApp) {
    jitsiApp.initAppObject();
    this.xmpp = jitsiApp.xmpp;
    this.isConnected = (jitsiApp.xmpp.getConnection() != null && jitsiApp.xmpp.getConnection().connected);
}

angular
    .module('ajmPartial', [jitsiMeet])
    .controller('PartialAppCtrl', PartialAppCtrl);

function PartialAppCtrl(connectionquality, desktopsharing, RTC, settings, statistics, xmpp) {
    vm = this;
    vm.xmpp = xmpp;
    vm.isConnected = (xmpp.getConnection() != null && xmpp.getConnection().connected);

    APP.UI = {addListener: function() {}};
    APP.connectionquality = connectionquality;
    APP.statistics = statistics;
    APP.RTC = RTC;
    APP.desktopsharing = desktopsharing;
    APP.xmpp = xmpp;
    APP.settings = settings;
}
