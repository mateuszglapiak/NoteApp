//
//  NoteDetailView.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    @EnvironmentObject var manager: ContextManager
    
    var body: some View {
        Form {
            Section(header:
                        TextField("You can put your title here...",
                                  text: $note.title,
                                  onEditingChanged: { if !$0 { manager.editNote(note: note) }}
                                 ).textCase(nil)
            ) {
                DetectableTextEditor(
                    text: $note.content,
                    model: DetectableTextEditorModel(time: .seconds(0.5)) {
                        manager.editNote(note: note)
                    }
                )
                .frame(minHeight: 450)
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoteDetailView(note: Binding.constant(Note(title: "Title", content: "Content")))
        }
    }
}
