//
//  NoteApp.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

@main
struct NoteApp: App {
    @StateObject var context = ContextManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(context)
        }
    }
}
