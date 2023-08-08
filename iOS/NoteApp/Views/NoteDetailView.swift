//
//  NoteDetailView.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct NoteDetailView: View {
    @Binding var note: Note
    
    var body: some View {
        Form {
            Section(header:
                TextField("You can put your title here...", text: $note.title).textCase(nil)
            ) {
                TextEditor(text: $note.content)
                    .frame(minHeight: 450)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NoteDetailView(note: Binding.constant(Note(title: "Title", content: "Content")))
        }
    }
}
