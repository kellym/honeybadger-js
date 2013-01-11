class Honeybadger.Notice
  constructor: (@options = {}) ->
    @stackInfo = @options.stackInfo || (@options.error && TraceKit.computeStackTrace(@options.error))
    @trace = @_parseBacktrace(@stackInfo?.stack)
    @class = @stackInfo?.name
    @message = @stackInfo?.message
    @url = document.URL
    @project_root = Honeybadger.configuration.project_root
    @environment = Honeybadger.configuration.environment
    @component = Honeybadger.configuration.component
    @action = Honeybadger.configuration.action

    @context = {}
    for k,v of Honeybadger.context
      @context[k] = v
    if @options.context
      for k,v of @options.context
        @context[k] = v

  toJSON: ->
    JSON.stringify
      notifier:
        name: 'honeybadger.js'
        url: 'https://github.com/honeybadger-io/honeybadger-js'
        version: Honeybadger.version
      error:
        class: @class
        message: @message
        backtrace: @trace
      request:
        url: @url
        component: @component
        action: @action
        context: @context
      server:
        project_root: @project_root
        environment_name: @environment

  _parseBacktrace: (stack = []) ->
    backtrace = []
    for trace in stack
      backtrace.push
        file: trace.url.replace(Honeybadger.configuration.project_root, '[PROJECT_ROOT]'),
        number: trace.line,
        method: trace.func
    backtrace
