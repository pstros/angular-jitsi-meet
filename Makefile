DIST := dist
BUNDLE := ${DIST}/angular-jitsi-meet.js
ANGULAR := angular
JITSI := jitsi
JITSI_MODULES := ${JITSI}/modules
JITSI_SERVICE := ${JITSI}/service

.PHONY: dist init clean test build browserify example publish

dist: clean init coffeelint build browserify copy test

init:
	npm install

clean:
	rm -rf ${ANGULAR}/ ${JITSI}/ ${DIST}/ coverage/

copy:
	mkdir -p ${JITSI_MODULES}
	cp -r node_modules/jitsi-meet/modules/* ${JITSI_MODULES}
	mkdir -p ${JITSI_SERVICE}
	cp -r node_modules/jitsi-meet/service/* ${JITSI_SERVICE}

coffeelint:
	node_modules/.bin/coffeelint src/**/*.coffee

build:
	node_modules/.bin/coffee -o ${ANGULAR}/ -c src/

browserify: build
	mkdir -p ${DIST}/
	node_modules/.bin/browserify -e index.js -o ${BUNDLE}

test: browserify
	node_modules/karma/bin/karma start karma.conf.coffee --single-run

example: dist
	cd example && rm -r node_modules/angular-jitsi-meet/ app-bundle.js && npm install && npm run browserify
	@echo 'Please open example/index.html in a browser'

publish: dist
	npm publish

