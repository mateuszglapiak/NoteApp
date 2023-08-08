//
//  ContentView.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: ContextManager
    
    var body: some View {
        NavigationView {
            ListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let context: ContextManager = {
            let context = ContextManager()
            context.current.notes = [
                Note(title: "Note 1", content: "Note content....."),
                Note(title: "Note 2", content: "Note content.....")
            ]
            return context
        }()
        ContentView()
            .environmentObject(context)
    }
}
