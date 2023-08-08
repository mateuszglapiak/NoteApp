//
//  Note.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct Note : Codable, Hashable, Identifiable {
    var id = UUID()
    var title: String
    var content: String
}
