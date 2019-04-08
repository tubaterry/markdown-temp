tableOfContents = require './tools/toc'

module.exports =
class markdownToolkit


  constructor: (@editor) ->
    @buffer = @editor.buffer

    # TOC
    @buffer.mdtkToc ?= new tableOfContents(@buffer)

    #Wrap-up
    myeditor = @editor.id
    console.log("Setup mtdk for #{myeditor}")
