PATH := ./node_modules/.bin:${PATH}
BUNDLE := angular-jitsi-meet.js

.PHONY: all test clean

init:
	npm install

clean:
	rm -rf dist/
	rm -rf lib/
	rm ${BUNDLE}

test:
	coffeelint src/**/*.coffee

build:
	coffee -o lib/ -c src/

browserify:
	browserify -e index.js -s APP -o ${BUNDLE}

dist: clean init test build browserify

default: dist
#publish: dist
	#npm publish

