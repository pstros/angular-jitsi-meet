# Angular Jitsi Meet
Angular Wrappers For Jitsi Meet Modules

[![Build Status](https://travis-ci.org/pstros/angular-jitsi-meet.svg?branch=master)](https://travis-ci.org/pstros/angular-jitsi-meet)

# Description
Provides CommonJS modules which provide angular services which wrap select jitsi-meet modules (such as xmpp).  
These can be brought into a webapp using browserify.

## Usage
To use jitsi-meet's xmpp module in your angular project

1. Include angular-jitsi-meet in your project's package.json
2. Add require('angular-jitsi-meet') to the file which declares your angular module
3. Add 'jm.xmpp' as a dependency of your angular module
4. Add the XmppService as a dependency of your controller, directive, or service

Instead of loading all modules with require('angular-jitsi-meet') you could load just the xmpp module with 
require('angular-jitsi-meet/angular/xmpp'). You can also get the name of the angular module from the required module.
See the example below.
    
    xmpp = require('angular-jitsi-meet/angular/xmpp');
    angular
        .module('app', [xmpp.name])

## Run tests

    make test

## Example
You can see and build (browserify) an example in the example directory.  Make sure you've run make on the 
angular-jitsi-meet module first since the example uses a local node module dependency

    make
    cd example
    npm install
    npm run browserify

Then open example/index.html in a browser