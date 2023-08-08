//
//  NoteResponse.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct NoteResponse: Codable, Hashable {
    var acknowledged: Bool
    var insertedId: String
}

extension NoteResponse {
    static func failed() -> Self {
        return .init(
            acknowledged: false,
            insertedId: String()
        )
    }
}
