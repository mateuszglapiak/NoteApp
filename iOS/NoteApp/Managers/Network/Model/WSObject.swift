//
//  WSObject.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct WSObject: Decodable {
    var method: String
    var id: String
}

extension WSObject {
    enum WSObjectMethod: String {
        case insertOne, update, delete
    }
}
