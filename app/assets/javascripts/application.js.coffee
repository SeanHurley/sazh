//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require codemirror
//= require codemirror/modes/ruby
//= require codemirror/addons/dialog/dialog
//= require codemirror/keymaps/vim
//= require opal
//= require opal-parser
//= require opal-jquery
//= require_tree .

ready = () ->
  page = $("body").data("page")
  klass = window[page]
  if class?
    instance = new klass
    instance.init()

$(document).ready(ready)
