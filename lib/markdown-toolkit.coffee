{ CompositeDisposable } = require 'atom';

markdownToolkit = require './mdtk'

module.exports =

  # @subscriptions = new CompositeDisposable

  activate: (state) ->
    @commandInit()

    # watch for new editors, watch for their grammars
    atom.workspace.observeTextEditors (editor) ->
      editor.observeGrammar (thisGrammar) ->
        thisBuffer=editor.buffer
        idnum = editor.id
        if thisGrammar.name.match /^.*(m|M)(arkdown).*$/g
          thisBuffer.mdtk ?= new markdownToolkit(editor)
          thisBuffer.mdtk.toolInit(thisBuffer)
        else
          # this is definitely gonna break if someone's got the same file open under different grammars.
          # that's tomorrow's problem.
          if thisBuffer.mdtk?
            delete thisBuffer.mdtk

      # Save this for if we need to do any cleanup?
      # editor.onDidDestroy () ->
      #   idnum = editor.id
      #   console.log "Destroyed editor ID: #{idnum}"

  # serialize: () ->
    # nothing at the moment

  # deserialize: () ->
    # nothing at the moment


  commandInit: () ->
    # Create commands
    atom.commands.add 'atom-text-editor', 'mdtk:toc-insert': ->
      editor = atom.workspace.getActiveTextEditor()
      if editor.buffer.mdtk?
        if editor.buffer.mdtk.toc?
         editor.buffer.mdtk.toc.insertCmd()
    atom.commands.add 'atom-text-editor', 'mdtk:toc-update': ->
      editor = atom.workspace.getActiveTextEditor()
      if editor.buffer.mdtk?
        if editor.buffer.mdtk.toc?
         editor.buffer.mdtk.toc.updateCmd()

    # This is where we setup our higher-level callbacks
    # if thisEditor.getGrammar().packageName isnt undefined
    #   thisGrammar = thisEditor.getGrammar().packageName
    #   if thisGrammar.match /^.*(markdown|gfm).*$/g
        # @toc = new Toc(thisEditor)
        # @toc.init()
        # atom.commands.add 'atom-workspace', 'markdown-toc:create': =>
        #     @toc = new Toc(thisEditor)
        #     @toc.create()
        # atom.commands.add 'atom-workspace', 'markdown-toc:update': =>
        #     @toc = new Toc(thisEditor)
        #     @toc.update()
        # atom.commands.add 'atom-workspace', 'markdown-toc:delete': =>
        #     @toc = new Toc(thisEditor);
        #     @toc.delete()
        # atom.commands.add 'atom-workspace', 'markdown-toc:toggle': =>
        #     @toc = new Toc(thisEditor)
        #     @toc.toggle()

  # No need to bother with this one I think - unless we decide to hold something external open?
  # deactivate: ->
  #   @toc.destroy()
