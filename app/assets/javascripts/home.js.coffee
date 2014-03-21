class HomeIndex

  constructor: ->
    @flush = []

  init: ->
    @myCodeMirror = CodeMirror(document.body, {
      keyMap: "vim",
      lineNumbers: true,
      matchBrackets: true,
      mode:  "ruby",
      showCursorWhenSelecting: true,
      theme: "solarized",
      value: "def self.test\n  puts \"Hello\"\nend\n\ntest\n",
      vimMode: true,
    })
    $('button')[0].onclick = @evalCode
    Opal.gvars.stdout.$puts = @overridePuts
    CodeMirror.commands.save = @evalCode

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
