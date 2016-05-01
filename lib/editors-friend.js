'use babel';

import EditorsFriendView from './editors-friend-view';
import { CompositeDisposable } from 'atom';

export default {

  editorsFriendView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.editorsFriendView = new EditorsFriendView(state.editorsFriendViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.editorsFriendView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'editors-friend:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.editorsFriendView.destroy();
  },

  serialize() {
    return {
      editorsFriendViewState: this.editorsFriendView.serialize()
    };
  },

  toggle() {
    console.log('EditorsFriend was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
