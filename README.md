# Angular Jitsi Meet
Angular Wrappers For Jitsi Meet Modules

[![Build Status](https://travis-ci.org/pstros/angular-jitsi-meet.svg?branch=master)](https://travis-ci.org/pstros/angular-jitsi-meet)

# Description
Provides CommonJS modules which provide angular services which wrap select jitsi-meet modules (such as xmpp, RTC). 
These can be used in a webapp with browserify.  

When angular-jitsi-meet is required the jitsi global APP object is created and attached to window, each jitsi-meet 
module is wrapped in angular, and the jitsi-meet events are wired up to the angular event bus. The angular service 
names match the jitsi-meet module names on the APP object.

The general file structure within the published module is:

    ├── index.js                        - main entrypoint for the module, requires ./lib
    ├── dist                            - dist files
    │   ├── app-bundle.js               -   a pre-browserified version of angular-jitsi-meet
    ├── lib                             - angular module definitions/generators
    │   ├── jitsi                       -   jitsi files
    │   ├── common                      -   shared files
    │   │   ├── EventAdapter            -     helper for wiring up events
    │   │   ├── AngularServiceGenerator -     helper for generating angular services

## Usage
To load all jitsi-meet modules in your angular project

1. Add angular-jitsi-meet to your project's package.json (npm install angular-jitsi-meet)
2. Add require('angular-jitsi-meet') to the file which declares your app's angular module
3. Add 'jm' as a dependency of your angular module (or put the require statement above in the dependency array) 
4. Add a jitsi module (xmpp, RTC, settings, statistics, connectionquality, desktopsharing, or jitsiApp) as a 
   dependency of your controller, directive, or service

bash

    npm install angular-jitsi-meet --save

app.js

    angular.module('app', [require('angular-jitsi-meet')])
      .run(function(xmpp, RTC) {
        //use the xmpp, RTC modules here
      });

## Run unit tests

    make test
    
## Releases/Publishing
There are make targets for releasing major, minor, and patch versions as well as publishing to npm.  The release 
targets are in the format: ```release-<major, minor or patch>```. See the example below for releasing a patch
    
    make release-patch pubish

## Example
There's an example you can build by running:  

    make example

Then open example/index.html in a browser