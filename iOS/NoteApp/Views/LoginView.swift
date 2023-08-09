//
//  LoginView.swift
//  NoteApp
//
//  Created by Mateusz on 09/08/2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var manager: ContextManager
    
    @State var serverUrl:String = "localhost"
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Server:")
                TextField("IP or localhost", text: $serverUrl).textFieldStyle(.roundedBorder)
            }
            NavigationLink(isActive: $isActive) {
                ListView()
            } label: {
                Button("Connect") {
                    isActive = manager.connect(host: serverUrl)
                }
            }
        }.padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
