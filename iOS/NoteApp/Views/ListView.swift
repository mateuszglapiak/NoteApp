//
//  ListView.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var context: ContextManager
    
    var body: some View {
        ZStack {
            List {
                ForEach($context.notes) { note in
                    NavigationLink {
                        NoteDetailView(note: note)
                    } label: {
                        ListNoteCell(note: note.wrappedValue)
                    }
                }
                .onDelete { context.removeNote(offset: $0) }
            }
            .navigationTitle("Notes")
            .toolbar {
                EditButton()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        context.addNote(title: "", content: "")
                    } label: {
                        HStack() {
                            Image(systemName: "plus.circle.fill")
                            Text("Add note")
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        let context: ContextManager = {
            let context = ContextManager()
            context.notes = [
                Note(title: "Note 1", content: "Note content....."),
                Note(title: "Note 2", content: "Note content....."),
                Note(title: "Note 3", content: "Note content....."),
                Note(title: "Note 4", content: "Note content.....")
            ]
            return context
        }()
        ListView()
            .environmentObject(context)
    }
}
