//
//  Context.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

class Context: ObservableObject {
    @Published var notes = [Note]()
}
