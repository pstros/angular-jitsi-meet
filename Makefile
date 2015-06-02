BUNDLE := dist/angular-jitsi-meet.js

.PHONY: dist init clean test build browserify publish

dist: clean init test build browserify

init:
	npm install

clean:
	rm -f $(BUNDLE)
	rm -rf lib/

test:
	node_modules/.bin/coffeelint src/**/*.coffee

build:
	node_modules/.bin/coffee -o lib/ -c src/

browserify: build
	mkdir dist/
	node_modules/.bin/browserify -e index.js -s APP -o ${BUNDLE}

publish: dist
	npm publish

