tableOfContents = require './tools/toc'

module.exports =
class markdownToolkit


  constructor: (@editor) ->
    # Put any editor-level stuff here.
    #Wrap-up
    myeditor = @editor.id
    console.log("Setup mdtk for #{myeditor}")

  toolInit: (@buffer) ->
    console.log(@buffer)

    @buffer.mdtk.toc ?= new tableOfContents(@buffer)
