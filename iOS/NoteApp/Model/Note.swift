//
//  Note.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct Note : Codable, Hashable, Identifiable {
    private enum CodingKeys : String, CodingKey {
        case id = "_id", title, content
    }
    
    var id: String
    var title: String
    var content: String
    
    init(id: String = UUID().uuidString, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}
