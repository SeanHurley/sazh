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
    @image()

    @flush = []
    code = @myCodeMirror.getValue()
    try
      Opal.eval(code)
    catch err
      @puts("" + err + "\\\\n" + err.stack)

  image: ->
    canvas = $("<canvas/>")[0]
    img = $("img")[0]
    canvas.getContext("2d").drawImage(img, 0, 0, img.width, img.height)
    console.log pixelData = canvas.getContext('2d').getImageData(0, 0, 1, 1).data

  puts: (str) =>
    @flush.push(str)
    output = $(".output")[0]
    output.value = @flush.join("\n")

  overridePuts: =>
    for arg in arguments
      @puts(arg)

this.HomeIndex = HomeIndex
