DIST := dist
BUNDLE := ${DIST}/angular-jitsi-meet.js
LIB := lib
JITSI := jitsi
JITSI_MODULES := ${JITSI}/modules
JITSI_SERVICE := ${JITSI}/service

.PHONY: dist init clean test build browserify example publish

dist: clean init coffeelint build browserify test

init:
	npm install

clean:
	rm -rf ${LIB}/ ${JITSI}/ ${DIST}/ coverage/

coffeelint:
	node_modules/.bin/coffeelint src/**/*.coffee

build:
	node_modules/.bin/coffee -o ${LIB}/ -c src/

browserify: build
	mkdir -p ${DIST}/
	node_modules/.bin/browserify -e index.js -x jquery -o ${BUNDLE}

test: browserify
	node_modules/karma/bin/karma start karma.conf.coffee --single-run

example: dist
	cd example && rm -rf node_modules/angular-jitsi-meet/ app-bundle.js && npm install && npm run browserify
	@echo 'Please open example/index.html in a browser'

publish: dist
	npm publish

