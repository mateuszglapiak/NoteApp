//
//  Note.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct Note : Codable, Hashable, Identifiable {
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, content, access, owner
    }
    
    var id: String
    var title: String
    var content: String
    var access: [String]
    var owner: String
    
    init(id: String = UUID().uuidString, title: String, content: String, access: [String] = [], owner: String = "") {
        self.id = id
        self.title = title
        self.content = content
        self.access = access
        self.owner = owner
    }
    
    mutating func update(_ note: Note) {
        self.id = note.id
        self.title = note.title
        self.content = note.content
        self.access = note.access
        self.owner = note.owner
    }
}
