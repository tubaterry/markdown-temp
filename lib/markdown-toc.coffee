Toc = require './Toc'

module.exports =

  activate: (state) ->
    editorCount = 0
    while editorCount < atom.workspace.getTextEditors().length
      @initToc(atom.workspace.getTextEditors()[editorCount])
      editorCount++

    at = @
    atom.workspace.onDidAddTextEditor (event) ->
      at.initToc(event.textEditor)

  initToc: (thisEditor) ->
    if thisEditor.getGrammar().packageName isnt undefined
      thisGrammar = thisEditor.getGrammar().packageName
      if thisGrammar.match /^.*(markdown|gfm).*$/g
        @toc = new Toc(thisEditor)
        @toc.init()
        atom.commands.add 'atom-workspace', 'markdown-toc:create': =>
            @toc = new Toc(thisEditor)
            @toc.create()
        atom.commands.add 'atom-workspace', 'markdown-toc:update': =>
            @toc = new Toc(thisEditor)
            @toc.update()
        atom.commands.add 'atom-workspace', 'markdown-toc:delete': =>
            @toc = new Toc(thisEditor);
            @toc.delete()
        atom.commands.add 'atom-workspace', 'markdown-toc:toggle': =>
            @toc = new Toc(thisEditor)
            @toc.toggle()
  # deactivate: ->
  #   @toc.destroy()
