//
//  AlertModel.swift
//  NoteApp
//
//  Created by Mateusz on 09/08/2023.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var primaryButton: String
    var primaryButtonAction: () -> Void
}
