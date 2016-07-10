EditorsFriendView = require './editors-friend-view'
{CompositeDisposable} = require 'atom'

module.exports = EditorsFriend =
  editorsFriendView: null
  modalPanel: null
  subscriptions: null
  config:
    wordsToFind:
      type: 'array'
      default: ['we', 'in order to']
      items:
        type: 'string'
    wordsToReplace:
      type: 'array'
      default: ['you', 'to']
      items:
        type: 'string'

  activate: (state) ->

    atom.commands.add 'atom-workspace', 'editors-friend:authormore': => @authormore()
    atom.commands.add 'atom-workspace', 'editors-friend:fixwords': => @fixwords()

  deactivate: ->

  serialize: ->

  authormore: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.insertText('[author_more]')

  fixwords: ->
    if editor = atom.workspace.getActiveTextEditor()
      currentText = editor.getBuffer()
      wordsToReplaceArray = atom.config.get('editors-friend.wordsToReplace')

      for wordToFind, key in atom.config.get('editors-friend.wordsToFind')
        searchString = new RegExp(wordToFind, 'i')
        currentText.replace(searchString, wordsToReplaceArray[key])