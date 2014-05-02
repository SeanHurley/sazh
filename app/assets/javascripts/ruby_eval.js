(function() {

  var RubyEval = function() {
    this.flush = [];
    this.initialize();
  };

  RubyEval.prototype.initialize = function() {
    this.myCodeMirror = CodeMirror(document.getElementById("editor"), {
      keyMap: "vim",
      lineNumbers: true,
      matchBrackets: true,
      mode:  "ruby",
      showCursorWhenSelecting: true,
      theme: "solarized",
      value: "def test(pixel)\n  puts pixel\nend",
      vimMode: true
    });

    this.outputArea = CodeMirror(document.getElementById("viewer"), {
      readOnly: true,
      mode:  "ruby",
      theme: "solarized"
    });
    $('button')[0].onclick = this.evalCode;
    Opal.gvars.stdout.$puts = this.overridePuts.bind(this);
    CodeMirror.commands.save = this.evalCode.bind(this);
    this.myCodeMirror.focus();
  };

  RubyEval.prototype.evalCode = function() {
    var code = this.myCodeMirror.getValue();
    this.flush = [];
    try {
      Opal.eval(code);
      this.image();
    } catch(err) {
      this.puts(err);
      this.outputArea.setValue(this.flush.join("\n"));
    }
  };

  RubyEval.prototype.image = function() {
    var output = [];
    var image = this.imageData();
    for(var x=0; x < image.length; x++) {
      for(var y=0; y < image[x].length; y++) {
        array = image[x][y];
        var result = Opal.Object.$test(array)
        output.push(result);
      }
    }
    this.outputArea.setValue(this.flush.join("\n"));
  };

  RubyEval.prototype.imageData = function() {
    if(this.pixels !== undefined) {
      return this.pixels;
    }

    var canvas = $("<canvas/>")[0];
    var img = $("img")[0];
    canvas.getContext("2d").drawImage(img, 0, 0, img.width, img.height);
    var imageContext = canvas.getContext('2d');
    this.pixels = [];
    for(var x=0; x < img.height; x++) {
      this.pixels.push([]);
      for(var y=0; y < img.width; y++) {
        var pixel = imageContext.getImageData(x, y, 1, 1).data;
        this.pixels[x].push([pixel[0], pixel[1], pixel[2], pixel[3]]);
      }
    }
    return this.pixels;
  };

  RubyEval.prototype.puts = function(string) {
    this.flush.push(string);
  };

  RubyEval.prototype.overridePuts = function() {
    for(var i in arguments) {
      this.puts(arguments[i]);
    }
  };

  window.RubyEval = RubyEval;
}());
