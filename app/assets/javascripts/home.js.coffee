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
      @puts("" + err + "\n" + err.stack)
    @image()

  image: ->
    output = []
    for x in [0...@imageData().length]
      for y in [0...@imageData()[x].length]
        array = @imageData()[x][y]
        output.push Opal.Object.$test(array)
    @outputArea.setValue(@flush.join("\n"))

  imageData: ->
    return @pixels if @pixels

    canvas = $("<canvas/>")[0]
    img = $("img")[0]
    canvas.getContext("2d").drawImage(img, 0, 0, img.width, img.height)
    imageContext = canvas.getContext('2d')
    @pixels = []
    for x in [0...img.height]
      @pixels.push []
      for y in [0...img.width]
        pixel = imageContext.getImageData(x, y, 1, 1).data
        array = [pixel[i] for i in [0..3]]
        @pixels[x].push array
    @pixels


  puts: (str) =>
    @flush.push(str)

  overridePuts: =>
    for arg in arguments
      @puts(arg)

this.HomeIndex = HomeIndex
