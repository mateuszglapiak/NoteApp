//
//  ContextManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

@MainActor class ContextManager: ObservableObject {
    @Published var notes: [Note]
    
    init() {
        notes = [Note(title: "First note", content: "")]
    }
    
    func addNote(title: String, content: String) {
        print("add note")
        notes += [Note(title: title, content: content)]
    }
    
    func removeNote(id: UUID) {
        print("remove")
        notes = notes.filter { $0.id != id }
    }
    
    func removeNote(offset: IndexSet) {
        notes.remove(atOffsets: offset)
    }
}
