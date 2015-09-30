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

      # mocks
      'test/mocks.coffee'

      # client
      'src/**/*.coffee'

      # test
      'test/**/*Spec.coffee'
    ]

    # preprocess matching files before serving them to the browser
    # available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors:
      'src/common/**/*.coffee': ['coffee', 'coverage', 'commonjs']
      'test/common/**/*Spec.coffee': ['coffee', 'commonjs']
      'src/index.coffee': ['browserify']
      'src/jitsi/**/*.coffee': ['browserify']
      'test/indexSpec.coffee': ['browserify']
      'test/mocks.coffee': ['browserify']
      
  
    commonjsPreprocessor:
      shouldExecFile: (file) ->
        file.path.indexOf 'test/' > -1
      processContent: (content, file, cb) ->
        cb content
        
    browserify:
      transform: ['coffeeify']
      extensions: ['.coffee']
  
    # test results reporter to use
    # possible values: 'dots', 'progress'
    # available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['spec', 'coverage']

    coverageReporter:
      reporters: [
        type: 'html', subdir: 'report-html'
      ,
        type: 'text-summary'
      ]

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
