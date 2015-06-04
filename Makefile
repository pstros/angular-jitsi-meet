BUNDLE := dist/angular-jitsi-meet.js

.PHONY: dist init clean test build browserify publish

dist: clean init coffeelint build browserify test

init:
	npm install

clean:
	rm -f $(BUNDLE)
	rm -rf lib/

coffeelint:
	node_modules/.bin/coffeelint src/**/*.coffee

build:
	node_modules/.bin/coffee -o lib/ -c src/

browserify: build
	mkdir -p dist/
	node_modules/.bin/browserify -e index.js -s APP -o ${BUNDLE}

test:
	node_modules/karma/bin/karma start karma.conf.coffee

publish: dist
	npm publish

