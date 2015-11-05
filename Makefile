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

#source: https://andreypopp.com/posts/2013-05-16-makefile-recipes-for-node-js.html
define release
	VERSION=`node -pe "require('./package.json').version"` && \
	NEXT_VERSION=`node -pe "require('semver').inc(\"$$VERSION\", '$(1)')"` && \
	node -e "\
		var j = require('./package.json');\
		j.version = \"$$NEXT_VERSION\";\
		var s = JSON.stringify(j, null, 2);\
		require('fs').writeFileSync('./package.json', s);" && \
	git commit -m "Release v$$NEXT_VERSION" -- package.json && \
	git tag "v$$NEXT_VERSION" -m "Release v$$NEXT_VERSION"
endef

release-patch: build test
	@$(call release,patch)

release-minor: build test
	@$(call release,minor)

release-major: build test
	@$(call release,major)

publish: dist
	git push --tags origin HEAD:master
	npm publish

