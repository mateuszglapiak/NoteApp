//
//  Context.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import Foundation

struct Context {
    var notes = [Note]()
    var alertModel: AlertModel?
}

extension Context {
    var isAlertRequired: Bool {
        set {
            if !newValue { alertModel = nil }
        }
        get {
            alertModel != nil
        }
    }
}
