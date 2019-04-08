{ CompositeDisposable } = require 'atom';

markdownToolkit = require './mdtk'

module.exports =

  # @subscriptions = new CompositeDisposable

  activate: (state) ->
    console.log("mtdk activation")
    # console.log(state)
    @tocInit()

    # watch for new editors, watch for their grammars
    atom.workspace.observeTextEditors (editor) ->
      console.log(editor)
      editor.observeGrammar (thisGrammar) ->
        idnum = editor.id
        if thisGrammar.name.match /^.*(m|M)(arkdown).*$/g
          editor.mdtk ?= new markdownToolkit(editor)
        else
          if editor.mdtk?
            delete editor.mdtk
        console.log(thisGrammar.name)

      # Save this for if we need to do any cleanup?
      # editor.onDidDestroy () ->
      #   idnum = editor.id
      #   console.log "Destroyed editor ID: #{idnum}"

  # serialize: () ->
    # nothing at the moment

  # deserialize: () ->
    # nothing at the moment


  tocInit: () ->
    # Create commands


    # This is where we setup our higher-level callbacks
    console.log("toc callbacks")
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
