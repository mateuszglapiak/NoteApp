//
//  ContextManager.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

class ContextManager: ObservableObject {
    @Published var notes: [Note]
    
    init() {
        notes = [Note(title: "First note", content: "")]
    }
}
