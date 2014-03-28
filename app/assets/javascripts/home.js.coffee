class HomeIndex

  constructor: ->
    @flush = []

  init: ->
    @myCodeMirror = CodeMirror(document.getElementById("editor"), {
      keyMap: "vim",
      lineNumbers: true,
      matchBrackets: true,
      mode:  "ruby",
      showCursorWhenSelecting: true,
      theme: "solarized",
      value: "def test(pixel)\n  puts pixel\nend",
      vimMode: true,
    })
    @outputArea = CodeMirror(document.getElementById("viewer"), {
      readOnly: true,
      mode:  "javascript",
      theme: "solarized",
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
      @puts("" + err + "\\\\n" + err.stack)
    @image()

  image: ->
    canvas = $("<canvas/>")[0]
    img = $("img")[0]
    canvas.getContext("2d").drawImage(img, 0, 0, img.width, img.height)
    for y in [0...img.height]
      for x in [0...img.width]
        pixel = canvas.getContext('2d').getImageData(x, y, 1, 1).data
        console.log(pixel[0])
        array = [pixel[i] for i in [0..3]]
        Opal.Object.$test(array)

  puts: (str) =>
    @flush.push(str)
    @outputArea.setValue(@flush.join("\n"))

  overridePuts: =>
    for arg in arguments
      @puts(arg)

this.HomeIndex = HomeIndex
