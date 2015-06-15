# Angular Jitsi Meet
Angular Wrappers For Jitsi Meet Modules

[![Build Status](https://travis-ci.org/pstros/angular-jitsi-meet.svg?branch=master)](https://travis-ci.org/pstros/angular-jitsi-meet)

# Description
Provides CommonJS modules which provide angular services which wrap select jitsi-meet modules (such as xmpp).  
These can be brought into a webapp using browserify.

The angular service names match the jitsi-meet module names.  The general file structure within the published module is:

    ├── index.js                        - main entrypoint for the module, requires ./lib
    ├── dist                            - dist files
    │   ├── app-bundle.js               -   a pre-browserified version of angular-jitsi-meet
    ├── lib                             - angular module definitions/generators
    │   ├── AngularServiceGenerator     -   factory for generating angular modules/services for objects
    │   ├── ModuleDefinitions           -   definitions of the jitsi modules/events, used by AngularServiceGenerator
    │   ├── common                      -   shared files
    │   │   ├── EventAdapter            -     helper for wiring up events

## Usage
To load all jitsi-meet modules in your angular project

1. Include angular-jitsi-meet in your project's package.json
2. Add require('angular-jitsi-meet') to the file which declares your angular module
3. Add 'jm' as a dependency of your angular module
4. Add 'xmpp' as a dependency of your controller, directive, or service

bash

    npm install angular-jitsi-meet --save

app.js

    ajm = require('angular-jitsi-meet');
    angular
        .module('app', ['jm']) //could also be [ajm.name]
        .run(function(xmpp, RTC) {
          //use the xmpp, RTC modules here
        });

Instead of your angular app depending on all the jitsi-meet modules, you can load just the modules you want.
    
    ajm = require('angular-jitsi-meet');
    angular
        .module('app', [ajm.xmpp.name])

## Run unit tests

    make test

## Example
There's an example you can build by running:  

    make example

Then open example/index.html in a browser