//
//  DetectableTextEditor.swift
//  NoteApp
//
//  Created by Mateusz on 08/08/2023.
//

import SwiftUI
import Combine

struct DetectableTextEditor: View {
    @Binding var text: String
    @StateObject var model: DetectableTextEditorModel
    
    var body: some View {
        TextEditor(text: $text)
            .onChange(of: text) { _ in model.detector.send() }
            .onReceive(model.publisher) { model.onUpdate?() }
    }
}

struct DetectableTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        DetectableTextEditor(text: Binding.constant(""), model: DetectableTextEditorModel())
    }
}

