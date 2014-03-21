class HomeIndex

  constructor: ->
    @flush = []

  init: ->
    @myCodeMirror = CodeMirror(document.body, {
      value: "def self.test\n  puts \"Hello\"\nend\n\ntest\n",
      mode:  "ruby",
      theme: "solarized",
      lineNumbers: true
    })
    $('button')[0].onclick = this.evalCode
    Opal.gvars.stdout.$puts = @overridePuts

  evalCode: =>
    @flush = []
    code = @myCodeMirror.getValue()

    try
      Opal.eval(code)
    catch err
      @puts('' + err + "\\\\n" + err.stack)

  puts: (str) =>
    @flush.push(str)
    output = $(".output")[0]
    output.value = @flush.join("\n")

  overridePuts: =>
    for arg in arguments
      @puts(arg)

this.HomeIndex = HomeIndex
