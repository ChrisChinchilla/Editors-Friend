EditorsFriendView = require './editors-friend-view'
{CompositeDisposable} = require 'atom'

module.exports = EditorsFriend =
  editorsFriendView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @editorsFriendView = new EditorsFriendView(state.editorsFriendViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @editorsFriendView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'editors-friend:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'editors-friend:authormore': => @authormore()
    @subscriptions.add atom.commands.add 'atom-workspace', 'editors-friend:fixwords': => @fixwords()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @editorsFriendView.destroy()

  serialize: ->
    editorsFriendViewState: @editorsFriendView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      editor = atom.workspace.getActiveTextEditor()
      words = editor.getText().split(/\s+/).length
      @editorsFriendView.setCount(words)
      @modalPanel.show()

  authormore: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('[author_more]')

  fixwords: ->
    if editor = atom.workspace.getActiveTextEditor()
      currentText = editor.getBuffer()
      searchString = new RegExp('this', 'i')
      currentText.replace(searchString, 'you')