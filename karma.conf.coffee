module.exports = (config) ->
  config.set

    # base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: ''

    frameworks: [
      'mocha',
      'sinon-chai'
      'browserify'
      'commonjs'
    ]

    # list of files / patterns to load in the browser
    files: [
      # vendor
      'node_modules/angular/angular.js'
      'node_modules/angular-mocks/angular-mocks.js'
      

      # client
      'src/common/*.coffee'
      'src/AngularServiceGenerator.coffee'
      'src/member/MemberService.coffee'

      # test
      'test/mocks.coffee'
      'test/**/*Spec.coffee'
    ]

    # list of files to exclude
    exclude: [
    ]

    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors:
      'src/**/*.coffee': ['coffee', 'commonjs', 'coverage']
      'test/**/!(mocks).coffee': ['coffee', 'commonjs']
      'test/mocks.coffee': ['browserify']

    commonjsPreprocessor:
      shouldExecFile: (file) ->
        file.path.indexOf 'test/' > -1
      processContent: (content, file, cb) ->
        cb(content)
    
    browserify:
      transform: ['coffeeify']
  
    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['spec', 'coverage']

    # web server port
    port: 9876

    # enable / disable colors in the output (reporters and logs)
    colors: true

    # level of logging
    # possible values:
    # - config.LOG_DISABLE
    # - config.LOG_ERROR
    # - config.LOG_WARN
    # - config.LOG_INFO
    # - config.LOG_DEBUG
    logLevel: config.LOG_INFO

    # enable / disable watching file and executing tests whenever any file changes
    autoWatch: true

    # start these browsers
    # available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS']

    # Continuous Integration mode
    # if true, Karma captures browsers, runs the tests and exits
    singleRun: false
